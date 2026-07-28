import cv2
import pytesseract
import re
import numpy as np

def extract_text_and_name(img: np.ndarray) -> dict:
    """
    Extrait tout le texte d'une image et tente de repérer le Nom/Prénom.
    :param img: Image chargée via OpenCV (format BGR).
    :return: Dictionnaire contenant le texte brut et les informations extraites.
    """
    # 1. Prétraitement de l'image pour améliorer l'OCR
    # Convertir en niveaux de gris
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # Appliquer un filtre bilatéral pour enlever le bruit tout en gardant les bords nets
    filtered = cv2.bilateralFilter(gray, 9, 75, 75)
    
    # Thresholding adaptatif pour faire ressortir le texte noir sur fond clair
    binary = cv2.adaptiveThreshold(filtered, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                   cv2.THRESH_BINARY, 11, 2)
                                   
    # 2. Exécution de Tesseract
    # config: '--psm 6' suppose un bloc uniforme de texte, idéal pour les documents
    extracted_text = pytesseract.image_to_string(binary, config='--psm 6')
    
    # 3. Tentative d'extraction intelligente (Nom/Prénom)
    # Ceci est une extraction de base. Les CNI sénégalaises ont souvent les mots "Nom" et "Prénom".
    lines = extracted_text.split('\n')
    nom_trouve = "Inconnu"
    
    for i, line in enumerate(lines):
        line_clean = line.strip().upper()
        # Si on trouve "NOM" ou "SURNAME", on prend souvent le mot de la même ligne ou de la ligne suivante
        if "NOM" in line_clean or "SURNAME" in line_clean:
            # On tente de nettoyer pour récupérer la valeur à côté (ex: "Nom : DIOP" -> "DIOP")
            parts = re.split(r'[:|;|-]', line_clean)
            if len(parts) > 1 and len(parts[-1].strip()) > 1:
                nom_trouve = parts[-1].strip()
            # Sinon on regarde la ligne suivante si elle existe
            elif i + 1 < len(lines) and len(lines[i+1].strip()) > 1:
                nom_trouve = lines[i+1].strip()
            
            # Dès qu'on trouve quelque chose de plausible, on s'arrête
            if nom_trouve != "Inconnu":
                break

    return {
        "raw_text": extracted_text,
        "extracted_name": nom_trouve
    }
