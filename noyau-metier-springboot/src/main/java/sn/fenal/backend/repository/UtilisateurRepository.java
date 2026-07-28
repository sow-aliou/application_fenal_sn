package sn.fenal.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sn.fenal.backend.model.Utilisateur;

public interface UtilisateurRepository extends JpaRepository<Utilisateur, Integer> {
    Utilisateur findByTelephone(String telephone);
}
