package com.project.shopapp.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.*;
import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class ProductDTO {

    @NotBlank(message = "Title is required")
    @Size(min = 3, max = 200, message = "Title must between 3 and 200 characters")
    private String name;

    @Min(value = 0, message = "Price must be greater than or equal to 0")
    @Max(value = 1000000, message = "Price must be less than or equal to 1000000")
    private Float price;


    private String thumbnail;

    private String description;

    @JsonProperty("category_id")
    private String categoryId;
}
