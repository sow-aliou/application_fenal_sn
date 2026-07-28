package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class TransactionPaiement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idTransaction;
    
    private Float montant = 500f;
    
    private Boolean estValide = false;
    
    @OneToOne(mappedBy = "transaction")
    private SessionChat sessionChat;
    
    public Boolean verifierStatutAPI() {
        return this.estValide;
    }
}
