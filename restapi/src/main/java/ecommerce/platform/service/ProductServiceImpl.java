package ecommerce.platform.service;

import ecommerce.platform.model.Product;
import ecommerce.platform.mappers.ProductMapper;
import ecommerce.platform.dto.ProductDTO;
import ecommerce.platform.repository.ProductRepository;
import ecommerce.platform.service.interfaces.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;

    private static final Logger logger = LoggerFactory.getLogger(CategoryServiceImpl.class);

    @Autowired
    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<ProductDTO> getAllProducts() {
        logger.info("Fetching all products");
        List<Product> products = productRepository.findAll();
        return products.stream()
                .map(product -> ProductMapper.toDTO(product))
                .collect(Collectors.toList());
    }


    public ProductDTO getProductById(Long id) {
        logger.info("Fetching product by id:- "+id);
        Optional<Product> product = productRepository.findById(id);
        if (product.isPresent()) {
            return ProductMapper.toDTO(product.get());
        } else {
            throw new ResourceNotFoundException("Product not found with id: " + id);
        }
    }

    public ProductDTO createProduct(ProductDTO productDTO) {
        logger.info("Creating product");
        Product product = ProductMapper.toEntity(productDTO);
        Product savedProduct = productRepository.save(product);
        return ProductMapper.toDTO(savedProduct);
    }

    public ProductDTO updateProduct(Long id, ProductDTO productDTO) {
        logger.info("Updating product with id :-"+ id);
        Optional<Product> existingProduct = productRepository.findById(id);
        if (existingProduct.isPresent()) {
            Product product = ProductMapper.toEntity(productDTO);
            product.setId(id);
            Product savedProduct = productRepository.save(product);
            return ProductMapper.toDTO(savedProduct);
        } else {
            throw new ResourceNotFoundException("Product not found with id: " + id);
        }
    }

    public void deleteProduct(Long id) {
        logger.info("Deleting product with id :-"+ id);
        Optional<Product> existingProduct = productRepository.findById(id);
        if (existingProduct.isPresent()) {
            productRepository.deleteById(id);
        } else {
            throw new ResourceNotFoundException("Product not found with id: " + id);
        }
    }

}
