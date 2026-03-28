package com.example.noyau_metier_springboot.repository;

import com.example.noyau_metier_springboot.model.ObjetTrouve;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ObjetTrouveRepository extends JpaRepository<ObjetTrouve, Long> {

    // Trouver les objets par le Samaritain (pour son historique personnel)
    List<ObjetTrouve> findBySamaritainId(Long samaritainId);

    // Matching basique selon la règle stricte du document :
    // Type, Couleur, et Date de découverte qui doit être APRÈS la Date de Perte déclarée
    @Query("SELECT o FROM ObjetTrouve o WHERE o.type = :type AND (:couleur IS NULL OR o.couleur = :couleur) " +
           "AND o.dateDecouverte >= :datePerte AND o.statut = 'NOUVEAU'")
    List<ObjetTrouve> findMatchingObjets(
            @Param("type") String type, 
            @Param("couleur") String couleur, 
            @Param("datePerte") LocalDateTime datePerte);

    // Matching strict pour un Document Régalien (CNI/Passeport) basé sur l'OCR
    @Query("SELECT o FROM ObjetTrouve o WHERE o.type = :type AND o.ocrText LIKE %:prenomNom% AND o.statut = 'NOUVEAU'")
    List<ObjetTrouve> findMatchingDocument(
            @Param("type") String type, 
            @Param("prenomNom") String prenomNom);
            
    // Pour inclure la recherche PostGIS par rayon, on peut utiliser les fonctions spatiales natives (ST_DWithin)
    @Query(value = "SELECT * FROM objets_trouves o WHERE o.type = :type " +
           "AND ST_DWithin(o.lieu, ST_SetSRID(ST_MakePoint(:longitude, :latitude), 4326), :rayonEnMetres, true)", 
           nativeQuery = true)
    List<ObjetTrouve> findObjetsByLieuAndRayon(
            @Param("type") String type,
            @Param("longitude") double longitude,
            @Param("latitude") double latitude,
            @Param("rayonEnMetres") double rayonEnMetres);
}
