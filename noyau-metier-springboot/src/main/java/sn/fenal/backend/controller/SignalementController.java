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
}
