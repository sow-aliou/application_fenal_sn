package sn.fenal.backend.service;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import sn.fenal.backend.dto.IAResponse;
import sn.fenal.backend.model.DocumentRegalien;
import sn.fenal.backend.model.Utilisateur;
import sn.fenal.backend.model.enums.StatutObjet;
import sn.fenal.backend.model.enums.TypeDocument;
import sn.fenal.backend.repository.DocumentRegalienRepository;
import sn.fenal.backend.repository.UtilisateurRepository;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.UUID;

import sn.fenal.backend.model.AlertePerte;
import sn.fenal.backend.repository.AlertePerteRepository;

@Service
public class SignalementService {

    @Autowired
    private IAServiceClient iaServiceClient;

    @Autowired
    private DocumentRegalienRepository documentRegalienRepository;

    @Autowired
    private UtilisateurRepository utilisateurRepository;
    
    @Autowired
    private AlertePerteRepository alertePerteRepository;

    private final String UPLOAD_DIR = "uploads/images/";

    public DocumentRegalien declarerDocumentTrouve(MultipartFile file, String lieu, Double latitude, Double longitude, Integer idUtilisateur, String description) throws Exception {
        
        // 1. Récupérer l'utilisateur
        Utilisateur samaritain = utilisateurRepository.findById(idUtilisateur)
                .orElseThrow(() -> new Exception("Utilisateur introuvable"));

        // 2. Appeler l'IA pour flouter et OCR
        IAResponse iaResponse = iaServiceClient.processDocument(file);

        if (!iaResponse.isSuccess()) {
            throw new Exception("L'IA n'a pas pu traiter l'image.");
        }

        // 3. Sauvegarder l'image floutée sur le disque
        String nomFichierMasque = UUID.randomUUID().toString() + "_masque.jpg";
        sauvegarderImageBase64(iaResponse.getBlurred_image_base64(), nomFichierMasque);

        // 4. Créer l'entité DocumentRegalien
        DocumentRegalien document = new DocumentRegalien();
        document.setUtilisateur(samaritain);
        document.setDateSignalement(LocalDateTime.now());
        document.setLieu(lieu);
        document.setDescription(description);
        document.setStatut(StatutObjet.EN_LIGNE);
        document.setType(TypeDocument.CNI); // Par défaut pour le MVP, on pourrait le déduire de l'IA

        // Si l'IA a trouvé un nom, on le stocke (il sera crypté en base par AESEncryptor)
        if (iaResponse.getExtracted_name() != null && !iaResponse.getExtracted_name().isEmpty()) {
            document.setNomExtraitOCR(iaResponse.getExtracted_name());
        } else {
            document.setNomExtraitOCR("INCONNU");
        }

        document.setPhotoMasquee(UPLOAD_DIR + nomFichierMasque);
        
        // On ne stocke PAS la photo originale pour le strict respect de la CDP
        document.setPhotoOriginale(null);

        // 5. Gérer la localisation spatiale avec PostGIS
        if (latitude != null && longitude != null) {
            GeometryFactory geometryFactory = new GeometryFactory();
            Point localisation = geometryFactory.createPoint(new Coordinate(longitude, latitude));
            localisation.setSRID(4326);
            document.setLocalisation(localisation);
        }

        return documentRegalienRepository.save(document);
    }

    private void sauvegarderImageBase64(String base64Image, String nomFichier) throws IOException {
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Enlever le préfixe "data:image/jpeg;base64," si présent
        String partSeparator = ",";
        if (base64Image.contains(partSeparator)) {
            base64Image = base64Image.split(partSeparator)[1];
        }

        byte[] decodedBytes = Base64.getDecoder().decode(base64Image);
        try (FileOutputStream fos = new FileOutputStream(UPLOAD_DIR + nomFichier)) {
            fos.write(decodedBytes);
        }
    }

    public java.util.List<DocumentRegalien> rechercherDocuments(TypeDocument type, String lieu) {
        return documentRegalienRepository.findByFilters(type, lieu);
    }
    
    public AlertePerte declarerDocumentPerdu(TypeDocument type, String nom, String lieu, Double latitude, Double longitude, Integer idUtilisateur, String description) throws Exception {
        Utilisateur citoyen = utilisateurRepository.findById(idUtilisateur)
                .orElseThrow(() -> new Exception("Utilisateur introuvable"));
                
        AlertePerte alerte = new AlertePerte();
        alerte.setUtilisateur(citoyen);
        alerte.setDateSignalement(LocalDateTime.now());
        alerte.setLieu(lieu);
        alerte.setDescription(description);
        alerte.setTypeDocument(type);
        alerte.setNomSurLeDocument(nom);
        alerte.setEstVisible(true);
        
        if (latitude != null && longitude != null) {
            GeometryFactory geometryFactory = new GeometryFactory();
            Point localisation = geometryFactory.createPoint(new Coordinate(longitude, latitude));
            localisation.setSRID(4326);
            alerte.setLocalisation(localisation);
        }
        
        return alertePerteRepository.save(alerte);
    }
}
