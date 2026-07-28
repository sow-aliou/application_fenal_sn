package sn.fenal.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import sn.fenal.backend.model.DocumentRegalien;

@Repository
public interface DocumentRegalienRepository extends JpaRepository<DocumentRegalien, Integer> {
}
