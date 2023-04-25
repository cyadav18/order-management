package ecommerce.platform.mappers;

import ecommerce.platform.model.Product;
import ecommerce.platform.dto.ProductDTO;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Component;

@Component
public class ProductMapper {

    public static ProductDTO toDTO(@NotNull Product product) {
        ProductDTO productDTO = new ProductDTO();
        productDTO.setId(product.getId());
        productDTO.setSlug(product.getSlug());
        productDTO.setProductName(product.getProductName());
        productDTO.setSku(product.getSku());
        productDTO.setSalePrice(product.getSalePrice());
        productDTO.setComparePrice(product.getComparePrice());
        productDTO.setBuyingPrice(product.getBuyingPrice());
        productDTO.setQuantity(product.getQuantity());
        productDTO.setShortDescription(product.getShortDescription());
        productDTO.setProductDescription(product.getProductDescription());
        productDTO.setProductType(product.getProductType());
        productDTO.setPublished(product.isPublished());
        productDTO.setDisableOutOfStock(product.isDisableOutOfStock());
        productDTO.setNote(product.getNote());
        productDTO.setCreatedAt(product.getCreatedAt());
        productDTO.setUpdatedAt(product.getUpdatedAt());
        return productDTO;
    }

    public static Product toEntity(@NotNull ProductDTO productDTO) {
        Product product = new Product();
        product.setId(productDTO.getId());
        product.setSlug(productDTO.getSlug());
        product.setProductName(productDTO.getProductName());
        product.setSku(productDTO.getSku());
        product.setSalePrice(productDTO.getSalePrice());
        product.setComparePrice(productDTO.getComparePrice());
        product.setBuyingPrice(productDTO.getBuyingPrice());
        product.setQuantity(productDTO.getQuantity());
        product.setShortDescription(productDTO.getShortDescription());
        product.setProductDescription(productDTO.getProductDescription());
        product.setProductType(productDTO.getProductType());
        product.setPublished(productDTO.isPublished());
        product.setDisableOutOfStock(productDTO.isDisableOutOfStock());
        product.setNote(productDTO.getNote());
        product.setCreatedAt(productDTO.getCreatedAt());
        product.setUpdatedAt(productDTO.getUpdatedAt());
        return product;
    }
}
