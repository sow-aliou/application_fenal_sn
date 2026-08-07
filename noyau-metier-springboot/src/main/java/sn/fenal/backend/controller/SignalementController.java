package sn.fenal.backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sn.fenal.backend.model.DocumentRegalien;
import sn.fenal.backend.service.SignalementService;

@RestController
@RequestMapping("/api/signalements")
public class SignalementController {

    @Autowired
    private SignalementService signalementService;

    @PostMapping(value = "/trouve/document", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> declarerDocumentTrouve(
            @RequestParam("file") MultipartFile file,
            @RequestParam("lieu") String lieu,
            @RequestParam(value = "latitude", required = false) Double latitude,
            @RequestParam(value = "longitude", required = false) Double longitude,
            @RequestParam("idUtilisateur") Integer idUtilisateur,
            @RequestParam(value = "description", required = false) String description) {
        
        try {
            DocumentRegalien document = signalementService.declarerDocumentTrouve(
                    file, lieu, latitude, longitude, idUtilisateur, description);
                    
            return ResponseEntity.ok(document);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur lors de la déclaration: " + e.getMessage());
        }
    }

    @GetMapping("/trouve/document")
    public ResponseEntity<?> rechercherDocuments(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String lieu) {
        try {
            sn.fenal.backend.model.enums.TypeDocument typeDoc = null;
            if (type != null && !type.trim().isEmpty()) {
                typeDoc = sn.fenal.backend.model.enums.TypeDocument.valueOf(type.toUpperCase());
            }
            return ResponseEntity.ok(signalementService.rechercherDocuments(typeDoc, lieu));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Type de document invalide.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur: " + e.getMessage());
        }
    }

    @PostMapping("/perdu")
    public ResponseEntity<?> declarerDocumentPerdu(@RequestBody java.util.Map<String, Object> request) {
        try {
            String typeStr = (String) request.get("type");
            sn.fenal.backend.model.enums.TypeDocument type = null;
            if (typeStr != null && !typeStr.trim().isEmpty()) {
                type = sn.fenal.backend.model.enums.TypeDocument.valueOf(typeStr.toUpperCase());
            }

            String nom = (String) request.get("nom");
            String lieu = (String) request.get("lieu");
            String description = (String) request.get("description");
            Integer idUtilisateur = (Integer) request.get("idUtilisateur");

            Double latitude = null;
            if (request.get("latitude") != null) {
                latitude = Double.valueOf(request.get("latitude").toString());
            }
            Double longitude = null;
            if (request.get("longitude") != null) {
                longitude = Double.valueOf(request.get("longitude").toString());
            }

            sn.fenal.backend.model.AlertePerte alerte = signalementService.declarerDocumentPerdu(
                    type, nom, lieu, latitude, longitude, idUtilisateur, description);
            
            return ResponseEntity.ok(alerte);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur lors de la déclaration de perte: " + e.getMessage());
        }
    }
}
