package ecommerce.platform.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.math.BigDecimal;
import java.time.ZonedDateTime;

public class ProductDTO {

    private Long id;

    @JsonIgnore
    private String slug;
    private String productName;

    @JsonIgnore
    private String sku;
    private BigDecimal salePrice;
    private BigDecimal comparePrice;
    private BigDecimal buyingPrice;
    private int quantity;
    private String shortDescription;
    private String productDescription;
    private String productType;

    @JsonIgnore
    private boolean published;

    @JsonIgnore
    private boolean disableOutOfStock;
    private String note;

    @JsonIgnore
    private ZonedDateTime createdAt;

    @JsonIgnore
    private ZonedDateTime updatedAt;

    public ProductDTO() {

    }

    public ProductDTO(Long id, String slug, String productName, String sku, BigDecimal salePrice, BigDecimal comparePrice, BigDecimal buyingPrice, int quantity, String shortDescription, String productDescription, String productType, boolean published, boolean disableOutOfStock, String note, ZonedDateTime createdAt, ZonedDateTime updatedAt) {
        this.id = id;
        this.slug = slug;
        this.productName = productName;
        this.sku = sku;
        this.salePrice = salePrice;
        this.comparePrice = comparePrice;
        this.buyingPrice = buyingPrice;
        this.quantity = quantity;
        this.shortDescription = shortDescription;
        this.productDescription = productDescription;
        this.productType = productType;
        this.published = published;
        this.disableOutOfStock = disableOutOfStock;
        this.note = note;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }



    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public BigDecimal getComparePrice() {
        return comparePrice;
    }

    public void setComparePrice(BigDecimal comparePrice) {
        this.comparePrice = comparePrice;
    }

    public BigDecimal getBuyingPrice() {
        return buyingPrice;
    }

    public void setBuyingPrice(BigDecimal buyingPrice) {
        this.buyingPrice = buyingPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public boolean isPublished() {
        return published;
    }

    public void setPublished(boolean published) {
        this.published = published;
    }

    public boolean isDisableOutOfStock() {
        return disableOutOfStock;
    }

    public void setDisableOutOfStock(boolean disableOutOfStock) {
        this.disableOutOfStock = disableOutOfStock;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public ZonedDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(ZonedDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public ZonedDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(ZonedDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
