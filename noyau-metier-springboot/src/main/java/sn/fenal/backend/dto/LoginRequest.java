package sn.fenal.backend.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String telephone;
    private String motDePasse;
}
