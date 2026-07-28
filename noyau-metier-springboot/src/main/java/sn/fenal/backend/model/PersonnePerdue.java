package sn.fenal.backend.model;

import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class PersonnePerdue extends Signalement {
    
    private String nomPrenomEstime;
    private String photoVisage;
}
