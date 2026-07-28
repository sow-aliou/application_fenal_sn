package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Data
public abstract class Utilisateur {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idUtilisateur;
    
    @Column(unique = true, nullable = false)
    private String telephone;
    
    @Column(unique = true)
    private String email;
    
    @Column(nullable = false)
    private String motDePasse;
    
    private String resetOtp;
    
    private LocalDateTime otpExpiry;
    
    private LocalDateTime dateCreation;

    @PrePersist
    protected void onCreate() {
        dateCreation = LocalDateTime.now();
    }
}
