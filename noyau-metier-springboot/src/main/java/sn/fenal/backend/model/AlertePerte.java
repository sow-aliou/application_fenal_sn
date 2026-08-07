package sn.fenal.backend.model;

import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import sn.fenal.backend.model.enums.TypeDocument;
import sn.fenal.backend.util.AESEncryptor;
import jakarta.persistence.Convert;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class AlertePerte extends Signalement {
    
    private Boolean estVisible = false;

    @Enumerated(EnumType.STRING)
    private TypeDocument typeDocument;
    
    @Convert(converter = AESEncryptor.class)
    private String nomSurLeDocument;
}
