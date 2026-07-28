package sn.fenal.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import sn.fenal.backend.model.enums.TypeDocument;
import sn.fenal.backend.util.AESEncryptor;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
public class DocumentRegalien extends ObjetTrouve {
    
    @Enumerated(EnumType.STRING)
    private TypeDocument type;
    
    @Convert(converter = AESEncryptor.class)
    private String nomExtraitOCR;
    
    private String photoMasquee;
}
