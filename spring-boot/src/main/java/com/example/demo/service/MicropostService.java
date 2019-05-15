package com.example.demo.service;

import com.example.demo.domain.Micropost;
import com.example.demo.repository.MicropostRepository;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

@Service
@Transactional
public class MicropostService {
    private MicropostRepository micropostRepository;

    public MicropostService(MicropostRepository micropostRepository) {
        this.micropostRepository = micropostRepository;
    }

    public List<Micropost> findAll() {
        return micropostRepository.findAll();
    }

    public void save(String content) {
        micropostRepository.save(new Micropost(content));
    }

}
