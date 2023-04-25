    package ecommerce.platform.model;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.FetchType;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.JoinColumn;
    import javax.persistence.ManyToOne;
    import javax.persistence.Table;
    import java.math.BigDecimal;
    import java.time.ZonedDateTime;
    @Entity
    @Table(name = "products")
    public class Product {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        @Column(name = "slug", nullable = false, unique = true)
        private String slug;

        @Column(name = "product_name", nullable = false)
        private String productName;

        @Column(name = "sku")
        private String sku;

        @Column(name = "sale_price", nullable = false)
        private BigDecimal salePrice;

        @Column(name = "compare_price")
        private BigDecimal comparePrice;

        @Column(name = "buying_price")
        private BigDecimal buyingPrice;

        @Column(name = "quantity", nullable = false)
        private int quantity;

        @Column(name = "short_description", nullable = false)
        private String shortDescription;

        @Column(name = "product_description", nullable = false)
        private String productDescription;

        @Column(name = "product_type", nullable = false)
        private String productType;

        @Column(name = "published", nullable = false)
        private boolean published;

        @Column(name = "disable_out_of_stock", nullable = false)
        private boolean disableOutOfStock;

        @Column(name = "note")
        private String note;

        @Column(name = "created_at", nullable = false)
        private ZonedDateTime createdAt;

        @Column(name = "updated_at", nullable = false)
        private ZonedDateTime updatedAt;

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "created_by")
        private StaffAccount createdBy;

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "updated_by")
        private StaffAccount updatedBy;



        public Product() {
            this.createdAt = ZonedDateTime.now();
            this.updatedAt = ZonedDateTime.now();
        }

        public Product(Long id, String slug, String productName, String sku, BigDecimal salePrice, BigDecimal comparePrice, BigDecimal buyingPrice, int quantity, String shortDescription, String productDescription, String productType, boolean published, boolean disableOutOfStock, String note, ZonedDateTime createdAt, ZonedDateTime updatedAt, StaffAccount createdBy, StaffAccount updatedBy) {
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
            this.createdBy = createdBy;
            this.updatedBy = updatedBy;
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

        public StaffAccount getCreatedBy() {
            return createdBy;
        }

        public void setCreatedBy(StaffAccount createdBy) {
            this.createdBy = createdBy;
        }

        public StaffAccount getUpdatedBy() {
            return updatedBy;
        }

        public void setUpdatedBy(StaffAccount updatedBy) {
            this.updatedBy = updatedBy;
        }
    }