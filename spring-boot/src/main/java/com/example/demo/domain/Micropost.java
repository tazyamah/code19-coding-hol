package com.example.demo.domain;

import javax.persistence.*;

@Entity
@Table(name = "Microposts")
public class Micropost {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "MICRO_SEQ")
    @SequenceGenerator(sequenceName = "micropost_seq", allocationSize = 1, name = "MICRO_SEQ")
    private Long id;
    private String content;

    public Micropost() {
    }

    public Micropost(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
