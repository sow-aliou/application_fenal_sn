package com.example.noyau_metier_springboot.model;

import jakarta.persistence.*;
import lombok.*;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;

@Entity
@Table(name = "objets_trouves")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ObjetTrouve {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type; // ex: CNI, Passeport, Clés, Sac

    @Column
    private String couleur;

    @Column(columnDefinition = "geometry(Point,4326)") // PostGIS Point (WGS 84)
    private Point lieu;

    @Column(nullable = false)
    private LocalDateTime dateDecouverte;

    @Column(length = 1000)
    private String imageUrl; // Image originale (non exposée publiquement)

    @Column(length = 1000)
    private String aiMaskedImageUrl; // Image anonymisée par l'IA (exposée)

    @Column(columnDefinition = "TEXT")
    private String ocrText; // Données extraites par l'IA (OCR)

    @Column(nullable = false)
    private String statut; // NOUVEAU, REVENDIQUE, RESTITUE

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "samaritain_id", nullable = false)
    private Utilisateur samaritain; // Anonymat préservé (relations privées)

    @Column(nullable = false, updatable = false)
    private LocalDateTime dateSignalement = LocalDateTime.now();
}
