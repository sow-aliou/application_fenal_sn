package com.example.noyau_metier_springboot.controller;

import com.example.noyau_metier_springboot.model.Role;
import com.example.noyau_metier_springboot.model.Utilisateur;
import com.example.noyau_metier_springboot.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthRestController {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder;

    @PostMapping("/inscription")
    public ResponseEntity<?> inscrireCitoyen(@RequestBody Map<String, String> request) {
        String telephone = request.get("telephone");
        String motDePasse = request.get("motDePasse");

        if (utilisateurRepository.findByTelephone(telephone).isPresent()) {
            return ResponseEntity.badRequest().body(Map.of("erreur", "Ce numéro de téléphone est déjà enregistré."));
        }

        // Le profil crypte doit être fait par un service dédié (AES-256), on met "null" par défaut ou on fait l'implémentation
        Utilisateur citoyen = Utilisateur.builder()
                .telephone(telephone)
                .motDePasse(passwordEncoder.encode(motDePasse))
                .role(Role.CITOYEN)
                .profilCrypteAes("PROFIL_CRYPTE_SIMULE") // Simuler l'AES
                .build();

        utilisateurRepository.save(citoyen);

        return ResponseEntity.ok(Map.of("message", "Inscription réussie pour le numéro " + telephone));
    }

    // Endpoint pour login et OTP à construire par la suite...
}
