package com.example.hello_api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateTaskRequest(
        @NotBlank(message = "Title must not be blank")
        @Size(max = 100, message = "Title cannot exceed 100 characters")
        String title
) {
}