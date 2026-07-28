package sn.fenal.backend.model;

import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class AlertePerte extends Signalement {
    
    private Boolean estVisible = false;
}
