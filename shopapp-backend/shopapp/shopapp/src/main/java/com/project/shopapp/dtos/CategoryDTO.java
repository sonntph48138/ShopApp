package com.project.shopapp.dtos;

import jakarta.validation.constraints.NotEmpty;
import lombok.*;


@Data//toString
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDTO {
    @NotEmpty(message = "Category's name canot be empty")
    private String name;
}
