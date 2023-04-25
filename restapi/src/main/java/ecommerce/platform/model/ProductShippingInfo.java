package ecommerce.platform.model;

import ecommerce.platform.common.DimensionUnit;
import ecommerce.platform.common.VolumeUnit;
import ecommerce.platform.common.WeightUnit;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "product_shipping_info")
public class ProductShippingInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(nullable = false)
    private BigDecimal weight;

    @Enumerated(EnumType.STRING)
    @Column(name = "weight_unit", nullable = false)
    private WeightUnit weightUnit;

    @Column(nullable = false)
    private BigDecimal volume;

    @Enumerated(EnumType.STRING)
    @Column(name = "volume_unit", nullable = false)
    private VolumeUnit volumeUnit;

    @Column(name = "dimension_width", nullable = false)
    private BigDecimal dimensionWidth;

    @Column(name = "dimension_height", nullable = false)
    private BigDecimal dimensionHeight;

    @Column(name = "dimension_depth", nullable = false)
    private BigDecimal dimensionDepth;

    @Enumerated(EnumType.STRING)
    @Column(name = "dimension_unit", nullable = false)
    private DimensionUnit dimensionUnit;

    // Constructors, getters, and setters
    public ProductShippingInfo(){}

    public ProductShippingInfo(Long id, Product product, BigDecimal weight, WeightUnit weightUnit, BigDecimal volume, VolumeUnit volumeUnit, BigDecimal dimensionWidth, BigDecimal dimensionHeight, BigDecimal dimensionDepth, DimensionUnit dimensionUnit) {
        this.id = id;
        this.product = product;
        this.weight = weight;
        this.weightUnit = weightUnit;
        this.volume = volume;
        this.volumeUnit = volumeUnit;
        this.dimensionWidth = dimensionWidth;
        this.dimensionHeight = dimensionHeight;
        this.dimensionDepth = dimensionDepth;
        this.dimensionUnit = dimensionUnit;
    }

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

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }

    public WeightUnit getWeightUnit() {
        return weightUnit;
    }

    public void setWeightUnit(WeightUnit weightUnit) {
        this.weightUnit = weightUnit;
    }

    public BigDecimal getVolume() {
        return volume;
    }

    public void setVolume(BigDecimal volume) {
        this.volume = volume;
    }

    public VolumeUnit getVolumeUnit() {
        return volumeUnit;
    }

    public void setVolumeUnit(VolumeUnit volumeUnit) {
        this.volumeUnit = volumeUnit;
    }

    public BigDecimal getDimensionWidth() {
        return dimensionWidth;
    }

    public void setDimensionWidth(BigDecimal dimensionWidth) {
        this.dimensionWidth = dimensionWidth;
    }

    public BigDecimal getDimensionHeight() {
        return dimensionHeight;
    }

    public void setDimensionHeight(BigDecimal dimensionHeight) {
        this.dimensionHeight = dimensionHeight;
    }

    public BigDecimal getDimensionDepth() {
        return dimensionDepth;
    }

    public void setDimensionDepth(BigDecimal dimensionDepth) {
        this.dimensionDepth = dimensionDepth;
    }

    public DimensionUnit getDimensionUnit() {
        return dimensionUnit;
    }

    public void setDimensionUnit(DimensionUnit dimensionUnit) {
        this.dimensionUnit = dimensionUnit;
    }
}

