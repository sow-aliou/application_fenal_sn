package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import sn.fenal.backend.model.enums.StatutDemande;

@Entity
@Data
public class DemandeVerification {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idDemande;
    
    private String preuveFournie;
    
    @Enumerated(EnumType.STRING)
    private StatutDemande statut = StatutDemande.EN_ATTENTE;
    
    @ManyToOne
    @JoinColumn(name = "id_objet_trouve", nullable = false)
    private ObjetTrouve objetTrouve;
    
    @ManyToOne
    @JoinColumn(name = "id_reclamant", nullable = false)
    private Citoyen reclamant;
    
    public Boolean evaluerPreuve() {
        return this.statut == StatutDemande.ACCEPTEE;
    }
}
