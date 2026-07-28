package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Data
public class Message {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idMessage;
    
    @Column(columnDefinition = "TEXT")
    private String contenu;
    
    private LocalDateTime dateEnvoi;
    
    @ManyToOne
    @JoinColumn(name = "id_session", nullable = false)
    private SessionChat sessionChat;
    
    @ManyToOne
    @JoinColumn(name = "id_expediteur", nullable = false)
    private Citoyen expediteur;
    
    @PrePersist
    protected void onCreate() {
        dateEnvoi = LocalDateTime.now();
    }
}
