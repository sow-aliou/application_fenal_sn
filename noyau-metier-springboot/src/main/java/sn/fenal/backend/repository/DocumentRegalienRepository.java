package sn.fenal.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import sn.fenal.backend.model.DocumentRegalien;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sn.fenal.backend.model.enums.TypeDocument;
import java.util.List;

@Repository
public interface DocumentRegalienRepository extends JpaRepository<DocumentRegalien, Integer> {

    @Query("SELECT d FROM DocumentRegalien d WHERE d.statut = 'EN_LIGNE' " +
           "AND (:type IS NULL OR d.type = :type) " +
           "AND (:lieu IS NULL OR LOWER(d.lieu) LIKE LOWER(CONCAT('%', :lieu, '%'))) " +
           "ORDER BY d.dateSignalement DESC")
    List<DocumentRegalien> findByFilters(@Param("type") TypeDocument type, @Param("lieu") String lieu);
}
