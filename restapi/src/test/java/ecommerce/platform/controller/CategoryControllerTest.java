package ecommerce.platform.controller;
import ecommerce.platform.model.Category;
import ecommerce.platform.service.interfaces.CategoryService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

public class CategoryControllerTest {
    @Mock
    private CategoryService categoryService;

    @InjectMocks
    private CategoryController categoryController;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void testGetAllProductCategories() {
        // Create a list of categories to be returned by the service
        Category category1 = new Category(1L, "Category 1");
        Category category2 = new Category(2L, "Category 2");
        List<Category> categories = Arrays.asList(category1, category2);

        // Mock the categoryService.findAll() method to return the list of categories
        when(categoryService.findAll()).thenReturn(categories);

        // Call the controller method
        ResponseEntity<List<Category>> response = categoryController.getAllProductCategories();

        // Check that the response has a status of HttpStatus.OK
        assertEquals(HttpStatus.OK, response.getStatusCode());

        // Check that the response body contains the expected categories
        assertEquals(categories, response.getBody());
    }
}