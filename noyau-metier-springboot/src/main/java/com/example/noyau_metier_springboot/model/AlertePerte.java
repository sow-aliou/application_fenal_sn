package com.example.noyau_metier_springboot.model;

import jakarta.persistence.*;
import lombok.*;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;

@Entity
@Table(name = "alertes_perte")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AlertePerte {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type; // CNI, Passeport, Sac, Personne, etc.

    @Column
    private String couleur;

    @Column(columnDefinition = "geometry(Point,4326)") // Lieu estimé de perte (PostGIS)
    private Point lieu;

    @Column(nullable = false)
    private LocalDateTime datePerte;

    @Column(columnDefinition = "TEXT")
    private String detailsDocument; // Nom, Prenom, Date/Lieu Naissance si document régalien. JSON ou crypté

    @Column(nullable = false)
    private String statut; // ACTIF, MATCH_TROUVE, CLOTURE

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reclamant_id", nullable = false)
    private Utilisateur reclamant; // L'utilisateur ayant perdu l'objet

    @Column(nullable = false, updatable = false)
    private LocalDateTime dateCreationAlerte = LocalDateTime.now();
}
