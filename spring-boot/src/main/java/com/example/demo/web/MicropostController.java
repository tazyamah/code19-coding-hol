package com.example.demo.web;

import com.example.demo.form.Content;
import com.example.demo.service.MicropostService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class MicropostController {
    private final MicropostService micropostService;

    public MicropostController(MicropostService micropostService) {
        this.micropostService = micropostService;
    }

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("microposts", micropostService.findAll());
        return "index";
    }

    @GetMapping("/new")
    public String create(Model model) {
        model.addAttribute("content", new Content());
        return "new";
    }

    @PostMapping("/")
    public String save(Model model, @Validated Content content, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return "new";
        }

        micropostService.save(content.getValue());
        model.addAttribute("microposts", micropostService.findAll());
        return "index";
    }
}
