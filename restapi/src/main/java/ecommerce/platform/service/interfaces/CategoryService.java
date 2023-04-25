package ecommerce.platform.service.interfaces;

import ecommerce.platform.model.Category;

import java.util.List;
import java.util.Optional;

public interface CategoryService {
    List<Category> findAll();
    Optional<Category> findById(Long id);
    Category save(Category Category);
    void deleteById(Long id);
}