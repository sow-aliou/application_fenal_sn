package sn.fenal.backend.model;

import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import sn.fenal.backend.util.AESEncryptor;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class Citoyen extends Utilisateur {

    @Convert(converter = AESEncryptor.class)
    private String nom;
    
    @Convert(converter = AESEncryptor.class)
    private String prenom;
    
    @Convert(converter = AESEncryptor.class)
    private String dateNaissanceCryptee;
}
