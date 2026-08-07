package sn.fenal.backend.dto;

import lombok.Data;

@Data
public class UpdateCitoyenRequest {
    private String nom;
    private String prenom;
    private String email;
}
