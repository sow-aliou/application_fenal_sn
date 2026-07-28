package sn.fenal.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sn.fenal.backend.model.DemandeVerification;

public interface DemandeVerificationRepository extends JpaRepository<DemandeVerification, Integer> {
}
