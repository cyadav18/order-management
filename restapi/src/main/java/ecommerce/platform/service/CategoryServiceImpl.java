package ecommerce.platform.service;

import ecommerce.platform.model.Category;
import ecommerce.platform.repository.CategoryRepository;
import ecommerce.platform.service.interfaces.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    private static final Logger logger = LoggerFactory.getLogger(CategoryServiceImpl.class);

    @Autowired
    public CategoryServiceImpl(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    public List<Category> findAll() {
        try {
            logger.info("Fetching all categories ");
            return categoryRepository.findAll();
        } catch (DataAccessException e) {
            logger.error("An error occurred while fetching categories", e);
            throw new RuntimeException("Failed to fetch categories", e);
        }
    }

    @Override
    public Optional<Category> findById(Long id) {
        try {
            logger.info(" Finding the category by id:- "+ id);
            return categoryRepository.findById(id);
        } catch (DataAccessException e) {
            logger.error("An error occurred while finding the category by id: " + id, e);
            throw new ResourceNotFoundException("Category not found for id: " + id, e);
        }
    }

    @Override
    public Category save(Category category) {
        try {
            logger.info(" Saving the category ");
            return categoryRepository.save(category);
        } catch (DataIntegrityViolationException e) {
            logger.error("An error occurred while saving the category: " + category, e);
            throw new RuntimeException("Category name is already in use", e);
        } catch (DataAccessException e) {
            logger.error("An error occurred while saving the category: " + category, e);
            throw new RuntimeException("Failed to save category: " + category, e);
        }
    }

    @Override
    public void deleteById(Long id) {
        try {
            logger.info(" Deleting the category by id:- "+id);
            categoryRepository.deleteById(id);
        } catch (DataAccessException e) {
            logger.error("An error occurred while deleting the category by id: " + id, e);
            throw new ResourceNotFoundException("Category not found for id: " + id, e);
        }
    }
}
