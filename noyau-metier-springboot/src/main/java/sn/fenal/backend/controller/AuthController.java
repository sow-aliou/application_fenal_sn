package sn.fenal.backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sn.fenal.backend.dto.RegisterRequest;
import sn.fenal.backend.model.Citoyen;
import sn.fenal.backend.service.UtilisateurService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UtilisateurService utilisateurService;

    @PostMapping("/inscription")
    public ResponseEntity<?> inscrire(@RequestBody RegisterRequest request) {
        try {
            Citoyen citoyen = utilisateurService.inscrireCitoyen(request);
            // On ne renvoie pas le mot de passe !
            citoyen.setMotDePasse(null);
            return ResponseEntity.ok(citoyen);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur lors de l'inscription: " + e.getMessage());
        }
    }
}
