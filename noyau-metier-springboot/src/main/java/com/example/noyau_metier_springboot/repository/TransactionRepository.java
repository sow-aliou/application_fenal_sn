package com.example.noyau_metier_springboot.repository;

import com.example.noyau_metier_springboot.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {

    // Retrouver la transaction par Réclamant (Historique de ses paiements)
    List<Transaction> findByReclamantId(Long reclamantId);

    // Vérifier si un objet est déjà en cours de paiement ou a été payé (un Objet ne devrait être payé qu'une fois)
    Optional<Transaction> findByObjetTrouveId(Long objetTrouveId);

}
