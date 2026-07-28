package sn.fenal.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import sn.fenal.backend.dto.RegisterRequest;
import sn.fenal.backend.model.Citoyen;
import sn.fenal.backend.repository.UtilisateurRepository;
import java.time.LocalDateTime;

@Service
public class UtilisateurService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    public Citoyen inscrireCitoyen(RegisterRequest request) {
        // TODO: Hasher le mot de passe avec BCrypt dans une version future
        String passwordHash = request.getMotDePasse();

        Citoyen citoyen = new Citoyen();
        citoyen.setNom(request.getNom());
        citoyen.setPrenom(request.getPrenom());
        citoyen.setTelephone(request.getTelephone());
        citoyen.setEmail(request.getEmail());
        citoyen.setMotDePasse(passwordHash);
        citoyen.setDateCreation(LocalDateTime.now());

        // L'AESEncryptor chiffrera automatiquement le nom et le prénom
        return utilisateurRepository.save(citoyen);
    }
}
