package sn.fenal.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sn.fenal.backend.model.Signalement;

public interface SignalementRepository extends JpaRepository<Signalement, Integer> {
}
