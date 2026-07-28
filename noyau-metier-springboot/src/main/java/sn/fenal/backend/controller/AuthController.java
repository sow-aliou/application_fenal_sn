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

    @PostMapping("/connexion")
    public ResponseEntity<?> connecter(@RequestBody sn.fenal.backend.dto.LoginRequest request) {
        try {
            Citoyen citoyen = utilisateurService.connecterCitoyen(request.getTelephone(), request.getMotDePasse());
            citoyen.setMotDePasse(null);
            return ResponseEntity.ok(citoyen);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur de connexion: " + e.getMessage());
        }
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody java.util.Map<String, String> request) {
        try {
            String telephone = request.get("telephone");
            utilisateurService.genererOtp(telephone);
            return ResponseEntity.ok(java.util.Map.of("message", "Si le numéro existe, un code OTP a été envoyé."));
        } catch (Exception e) {
            // Pour des raisons de sécurité, on devrait renvoyer OK même si le compte n'existe pas,
            // mais pour ce MVP on va renvoyer l'erreur pour faciliter le débogage.
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody java.util.Map<String, String> request) {
        try {
            String telephone = request.get("telephone");
            String otp = request.get("otp");
            String nouveauMotDePasse = request.get("nouveauMotDePasse");
            
            utilisateurService.reinitialiserMotDePasse(telephone, otp, nouveauMotDePasse);
            return ResponseEntity.ok(java.util.Map.of("message", "Mot de passe réinitialisé avec succès."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
