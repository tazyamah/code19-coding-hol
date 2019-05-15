package com.example.demo.form;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotEmpty;

public class Content {

    @NotEmpty
    private String value;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
