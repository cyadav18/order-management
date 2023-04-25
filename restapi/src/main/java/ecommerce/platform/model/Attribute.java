package ecommerce.platform.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "attributes")
public class Attribute {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "attribute_name", nullable = false)
    private String attributeName;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @ManyToOne
    @JoinColumn(name = "created_by", referencedColumnName = "id")
    private StaffAccount createdBy;

    @ManyToOne
    @JoinColumn(name = "updated_by", referencedColumnName = "id")
    private StaffAccount updatedBy;

    // constructor, getters, and setters

    public Attribute(){

    }

    public Attribute( Long id,String attributeName, LocalDateTime createdAt, LocalDateTime updatedAt, StaffAccount createdBy, StaffAccount updatedBy) {
        this.id =id;
        this.attributeName = attributeName;
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

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
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
