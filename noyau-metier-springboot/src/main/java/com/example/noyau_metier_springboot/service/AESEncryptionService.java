package com.example.noyau_metier_springboot.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

@Service
public class AESEncryptionService {

    // En production: la clé doit venir du Vault ou .env sécurisé (32 octets = AES 256)
    @Value("${aes.secret-key:ABCDEFGHIJKLMNOPQRSTUVWXYZ123456}")
    private String secretKeyString;

    private static final String ALGORITHM = "AES";

    public String nomDAlgorithmeCryptage() {
        return ALGORITHM;
    }

    public String crypt(String texteClair) {
        try {
            SecretKeySpec key = new SecretKeySpec(secretKeyString.getBytes(), ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] encryptedData = cipher.doFinal(texteClair.getBytes());
            return Base64.getEncoder().encodeToString(encryptedData);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du cryptage AES", e);
        }
    }

    public String decrypt(String texteCrypte) {
        try {
            SecretKeySpec key = new SecretKeySpec(secretKeyString.getBytes(), ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, key);
            byte[] decryptedData = cipher.doFinal(Base64.getDecoder().decode(texteCrypte));
            return new String(decryptedData);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors du décryptage AES", e);
        }
    }
}
