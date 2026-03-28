package com.example.noyau_metier_springboot.repository;

import com.example.noyau_metier_springboot.model.AlertePerte;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AlertePerteRepository extends JpaRepository<AlertePerte, Long> {

    // Récupérer toutes les alertes déposées par un citoyen (invisible au public)
    List<AlertePerte> findByReclamantId(Long reclamantId);

    // Fonctionnalité de Matching Système 
    // Pour que le backend puisse traiter en arrière plan les alertes non-clôturées
    List<AlertePerte> findByStatut(String statut);

}
