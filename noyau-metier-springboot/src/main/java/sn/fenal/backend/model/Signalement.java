package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import org.locationtech.jts.geom.Point;
import java.time.LocalDateTime;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Data
public abstract class Signalement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idSignalement;
    
    private LocalDateTime dateSignalement;
    
    // Nom textuel du lieu (ex: "Médina, Dakar")
    private String lieu;
    
    // Coordonnées spatiales PostGIS
    @Column(columnDefinition = "geometry(Point,4326)")
    private Point localisation;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_utilisateur", nullable = false)
    private Utilisateur utilisateur;
}
