package sn.fenal.backend.util;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.security.Key;
import java.util.Base64;

@Component
@Converter
public class AESEncryptor implements AttributeConverter<String, String> {

    private static final String AES = "AES";
    
    private static String secret;

    private static final String ALGO = "AES/ECB/PKCS5Padding";

    @Value("${fenal.aes.secret:1234567890123456}")
    public void setSecret(String secret) {
        AESEncryptor.secret = secret;
    }

    private Key getKey() {
        if (secret == null || secret.length() != 16) {
            // Fallback for tests (16 chars for AES-128)
            secret = "1234567890123456";
        }
        return new SecretKeySpec(secret.getBytes(), "AES");
    }

    @Override
    public String convertToDatabaseColumn(String attribute) {
        if (attribute == null) {
            return null;
        }
        try {
            Cipher cipher = Cipher.getInstance(ALGO);
            cipher.init(Cipher.ENCRYPT_MODE, getKey());
            return Base64.getEncoder().encodeToString(cipher.doFinal(attribute.getBytes()));
        } catch (Exception e) {
            throw new IllegalStateException("Erreur lors du chiffrement", e);
        }
    }

    @Override
    public String convertToEntityAttribute(String dbData) {
        if (dbData == null) {
            return null;
        }
        try {
            Cipher cipher = Cipher.getInstance(ALGO);
            cipher.init(Cipher.DECRYPT_MODE, getKey());
            return new String(cipher.doFinal(Base64.getDecoder().decode(dbData)));
        } catch (Exception e) {
            throw new IllegalStateException("Erreur lors du déchiffrement", e);
        }
    }
}
