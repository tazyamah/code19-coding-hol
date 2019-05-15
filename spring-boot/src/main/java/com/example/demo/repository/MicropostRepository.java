package com.example.demo.repository;

import com.example.demo.domain.Micropost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MicropostRepository extends JpaRepository<Micropost, String> {
}
