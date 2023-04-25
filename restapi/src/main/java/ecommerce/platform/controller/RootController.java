package ecommerce.platform.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;

@RestController
@RequestMapping
public class RootController {
    @GetMapping
    public String index(Model model) {
        model.addAttribute("pageTitle", "Taming Thymeleaf");
        model.addAttribute("scientists", Arrays.asList("Albert Einstein",
                "Niels Bohr",
                "James Clerk Maxwell"));
        return "index";
    }
}
