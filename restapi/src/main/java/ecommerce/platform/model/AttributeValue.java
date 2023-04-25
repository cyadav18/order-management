package ecommerce.platform.model;

import javax.persistence.*;

@Entity
@Table(name = "attribute_values")
public class AttributeValue {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "attribute_id", referencedColumnName = "id")
    private Attribute attribute;

    @Column(name = "attribute_value")
    private String attributeValue;

    @Column(name = "color")
    private String color;

    public AttributeValue(){

    }

    public AttributeValue( Long id,Attribute attribute, String attributeValue, String color) {
        this.id = id;
        this.attribute = attribute;
        this.attributeValue = attributeValue;
        this.color = color;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Attribute getAttribute() {
        return attribute;
    }

    public void setAttribute(Attribute attribute) {
        this.attribute = attribute;
    }

    public String getAttributeValue() {
        return attributeValue;
    }

    public void setAttributeValue(String attributeValue) {
        this.attributeValue = attributeValue;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}
