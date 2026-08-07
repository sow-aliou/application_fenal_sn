package sn.fenal.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import sn.fenal.backend.model.AlertePerte;

@Repository
public interface AlertePerteRepository extends JpaRepository<AlertePerte, Integer> {
}
