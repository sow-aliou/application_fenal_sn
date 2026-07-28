from fastapi import APIRouter, UploadFile, File, HTTPException
import base64
import cv2

from app.services.face_blur_service import blur_faces
from app.services.ocr_service import extract_text_and_name

router = APIRouter(prefix="/api/v1/documents", tags=["Documents"])

@router.post("/process")
async def process_document(file: UploadFile = File(...)):
    """
    Reçoit une image de document (CNI, Passeport), extrait le nom via OCR, 
    floute le visage et retourne l'image sécurisée en Base64.
    """
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Le fichier doit être une image.")
    
    try:
        # Lire les octets de l'image
        image_bytes = await file.read()
        
        # 1. Floutage du visage
        blurred_img = blur_faces(image_bytes)
        
        # 2. Extraction du texte (on peut utiliser l'image floutée ou l'image originale)
        # Il est souvent préférable d'utiliser l'image floutée pour ne pas conserver l'image originale en mémoire,
        # le visage n'est pas utile pour l'OCR du texte.
        ocr_result = extract_text_and_name(blurred_img)
        
        # 3. Encoder l'image floutée en Base64 pour la renvoyer au backend Java
        # On encode au format JPG
        success, encoded_image = cv2.imencode('.jpg', blurred_img)
        if not success:
            raise HTTPException(status_code=500, detail="Erreur lors de l'encodage de l'image.")
            
        b64_image = base64.b64encode(encoded_image.tobytes()).decode('utf-8')
        
        return {
            "success": True,
            "extracted_name": ocr_result["extracted_name"],
            "raw_text": ocr_result["raw_text"],
            "blurred_image_base64": f"data:image/jpeg;base64,{b64_image}"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
