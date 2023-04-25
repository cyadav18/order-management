package ecommerce.platform.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "gallery")
public class Gallery {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name = "image", nullable = false)
    private String image;

    @Column(name = "placeholder", nullable = false)
    private String placeholder;

    @Column(name = "is_thumbnail")
    private boolean isThumbnail;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public Gallery() {
        // empty constructor required by JPA
    }

    public Gallery(Product product, String image, String placeholder, boolean isThumbnail, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.product = product;
        this.image = image;
        this.placeholder = placeholder;
        this.isThumbnail = isThumbnail;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getPlaceholder() {
        return placeholder;
    }

    public void setPlaceholder(String placeholder) {
        this.placeholder = placeholder;
    }

    public boolean isThumbnail() {
        return isThumbnail;
    }

    public void setThumbnail(boolean thumbnail) {
        isThumbnail = thumbnail;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
