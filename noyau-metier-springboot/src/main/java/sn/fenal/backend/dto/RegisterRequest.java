package sn.fenal.backend.dto;

import lombok.Data;

@Data
public class RegisterRequest {
    private String nom;
    private String prenom;
    private String telephone;
    private String email;
    private String motDePasse;
}
