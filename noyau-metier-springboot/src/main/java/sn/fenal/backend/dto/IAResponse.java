package sn.fenal.backend.dto;

import lombok.Data;

@Data
public class IAResponse {
    private boolean success;
    private String extracted_name;
    private String raw_text;
    private String blurred_image_base64;
}
