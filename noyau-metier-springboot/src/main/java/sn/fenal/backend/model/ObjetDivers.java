package sn.fenal.backend.model;

import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class ObjetDivers extends ObjetTrouve {
    
    private String categorie;
    private String couleur;
}
