package ecommerce.platform.model;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "coupons")
public class Coupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "code", unique = true, nullable = false)
    private String code;

    @Column(name = "discount_value")
    private BigDecimal discountValue;

    @Column(name = "discount_type", nullable = false)
    private String discountType;

    @Column(name = "times_used", nullable = false)
    private BigDecimal timesUsed;

    @Column(name = "max_usage")
    private BigDecimal maxUsage;

    @Column(name = "order_amount_limit")
    private BigDecimal orderAmountLimit;

    @Column(name = "coupon_start_date")
    private LocalDateTime couponStartDate;

    @Column(name = "coupon_end_date")
    private LocalDateTime couponEndDate;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private StaffAccount createdBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "updated_by")
    private StaffAccount updatedBy;

    // Constructors, getters, and setters
    public Coupon(){}

    public Coupon(Long id, String code, BigDecimal discountValue, String discountType, BigDecimal timesUsed, BigDecimal maxUsage, BigDecimal orderAmountLimit, LocalDateTime couponStartDate, LocalDateTime couponEndDate, LocalDateTime createdAt, LocalDateTime updatedAt, StaffAccount createdBy, StaffAccount updatedBy) {
        this.id = id;
        this.code = code;
        this.discountValue = discountValue;
        this.discountType = discountType;
        this.timesUsed = timesUsed;
        this.maxUsage = maxUsage;
        this.orderAmountLimit = orderAmountLimit;
        this.couponStartDate = couponStartDate;
        this.couponEndDate = couponEndDate;
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getTimesUsed() {
        return timesUsed;
    }

    public void setTimesUsed(BigDecimal timesUsed) {
        this.timesUsed = timesUsed;
    }

    public BigDecimal getMaxUsage() {
        return maxUsage;
    }

    public void setMaxUsage(BigDecimal maxUsage) {
        this.maxUsage = maxUsage;
    }

    public BigDecimal getOrderAmountLimit() {
        return orderAmountLimit;
    }

    public void setOrderAmountLimit(BigDecimal orderAmountLimit) {
        this.orderAmountLimit = orderAmountLimit;
    }

    public LocalDateTime getCouponStartDate() {
        return couponStartDate;
    }

    public void setCouponStartDate(LocalDateTime couponStartDate) {
        this.couponStartDate = couponStartDate;
    }

    public LocalDateTime getCouponEndDate() {
        return couponEndDate;
    }

    public void setCouponEndDate(LocalDateTime couponEndDate) {
        this.couponEndDate = couponEndDate;
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
