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

    public Citoyen connecterCitoyen(String telephone, String motDePasse) throws Exception {
        // On cherche l'utilisateur par téléphone (qui est unique)
        Citoyen citoyen = utilisateurRepository.findAll().stream()
                .filter(u -> u instanceof Citoyen)
                .map(u -> (Citoyen) u)
                .filter(c -> telephone.equals(c.getTelephone()))
                .findFirst()
                .orElseThrow(() -> new Exception("Numéro de téléphone incorrect"));

        // Vérification basique du mot de passe (pour le MVP)
        if (!motDePasse.equals(citoyen.getMotDePasse())) {
            throw new Exception("Mot de passe incorrect");
        }

        return citoyen;
    }

    public void genererOtp(String telephone) throws Exception {
        Citoyen citoyen = utilisateurRepository.findAll().stream()
                .filter(u -> u instanceof Citoyen)
                .map(u -> (Citoyen) u)
                .filter(c -> telephone.equals(c.getTelephone()))
                .findFirst()
                .orElseThrow(() -> new Exception("Aucun compte trouvé avec ce numéro."));

        // Générer un code à 4 chiffres
        String otp = String.format("%04d", new java.util.Random().nextInt(10000));
        citoyen.setResetOtp(otp);
        citoyen.setOtpExpiry(LocalDateTime.now().plusMinutes(10));
        utilisateurRepository.save(citoyen);

        // Simulation de l'envoi de SMS
        System.out.println("=================================================");
        System.out.println("📱 [SIMULATION SMS] Envoi au " + telephone);
        System.out.println("Votre code de réinitialisation FÉÑAL est : " + otp);
        System.out.println("=================================================");
    }

    public void reinitialiserMotDePasse(String telephone, String otp, String nouveauMotDePasse) throws Exception {
        Citoyen citoyen = utilisateurRepository.findAll().stream()
                .filter(u -> u instanceof Citoyen)
                .map(u -> (Citoyen) u)
                .filter(c -> telephone.equals(c.getTelephone()))
                .findFirst()
                .orElseThrow(() -> new Exception("Aucun compte trouvé avec ce numéro."));

        if (citoyen.getResetOtp() == null || !citoyen.getResetOtp().equals(otp)) {
            throw new Exception("Code OTP incorrect.");
        }

        if (citoyen.getOtpExpiry().isBefore(LocalDateTime.now())) {
            throw new Exception("Le code OTP a expiré.");
        }

        citoyen.setMotDePasse(nouveauMotDePasse); // TODO: Hasher dans le futur
        citoyen.setResetOtp(null);
        citoyen.setOtpExpiry(null);
        utilisateurRepository.save(citoyen);
    }
}
