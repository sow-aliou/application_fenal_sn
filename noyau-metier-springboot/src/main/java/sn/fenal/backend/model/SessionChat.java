package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Data
public class SessionChat {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idSession;
    
    private LocalDateTime dateExpiration;
    
    private Boolean estActif = true;
    
    @OneToOne
    @JoinColumn(name = "id_transaction")
    private TransactionPaiement transaction;
    
    @ManyToOne
    @JoinColumn(name = "id_citoyen1")
    private Citoyen participant1;
    
    @ManyToOne
    @JoinColumn(name = "id_citoyen2")
    private Citoyen participant2;
    
    @OneToMany(mappedBy = "sessionChat", cascade = CascadeType.ALL)
    private List<Message> messages;
    
    public void fermerSession() {
        this.estActif = false;
    }
}
