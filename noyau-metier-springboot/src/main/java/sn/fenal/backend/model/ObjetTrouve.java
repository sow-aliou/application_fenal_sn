package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import sn.fenal.backend.model.enums.StatutObjet;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Data
@EqualsAndHashCode(callSuper = true)
public abstract class ObjetTrouve extends Signalement {
    
    private String photoOriginale;
    
    @Enumerated(EnumType.STRING)
    private StatutObjet statut;
    
    public String genererQRCodeRemise() {
        return "QR_" + this.getIdSignalement();
    }
}
