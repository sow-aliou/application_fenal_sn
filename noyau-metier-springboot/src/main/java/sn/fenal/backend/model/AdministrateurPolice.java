package sn.fenal.backend.model;

import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class AdministrateurPolice extends Utilisateur {

    private String matriculeID;
    private String grade;
}
