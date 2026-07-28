import cv2
import numpy as np

# Initialisation du détecteur de visage Haar Cascade
# cv2.data.haarcascades pointe vers le dossier où OpenCV stocke ses modèles pré-entraînés
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

def blur_faces(image_bytes: bytes) -> np.ndarray:
    """
    Détecte et floute les visages dans une image.
    :param image_bytes: Les octets de l'image brute (téléversée).
    :return: L'image traitée (format OpenCV BGR).
    """
    # Convertir les octets en tableau numpy
    nparr = np.frombuffer(image_bytes, np.uint8)
    # Décoder l'image avec OpenCV
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    if img is None:
        raise ValueError("Impossible de décoder l'image fournie.")

    # Convertir en niveaux de gris pour la détection (plus rapide et précis)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # Détection des visages
    # scaleFactor=1.1, minNeighbors=5 sont des valeurs standard robustes
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))
    
    # Pour chaque visage détecté, appliquer un flou
    for (x, y, w, h) in faces:
        # Extraire la zone du visage
        roi_color = img[y:y+h, x:x+w]
        
        # Appliquer un flou gaussien (kernel 99x99 pour un flou très fort)
        blurred = cv2.GaussianBlur(roi_color, (99, 99), 30)
        
        # Remplacer la zone originale par la zone floutée
        img[y:y+h, x:x+w] = blurred
        
    return img
