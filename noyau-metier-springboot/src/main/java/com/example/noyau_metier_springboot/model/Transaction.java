package com.example.noyau_metier_springboot.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reclamant_id", nullable = false)
    private Utilisateur reclamant; // L'utilisateur qui paie (Propriétaire)

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "objet_trouve_id", nullable = false)
    private ObjetTrouve objetTrouve; // L'objet revendiqué

    @Column(nullable = false)
    private Double montant; // Ex: 500.0 FCFA

    @Column(nullable = false)
    private String methodePaiement; // WAVE, ORANGEMONEY

    @Column(nullable = false)
    private String statut; // EN_ATTENTE, VALIDE, ECHOUE

    @Column(nullable = false)
    private boolean chatDebloque = false; // Devient true si le paiement réussit

    @Column(nullable = false)
    private LocalDateTime dateTransaction = LocalDateTime.now();
}
