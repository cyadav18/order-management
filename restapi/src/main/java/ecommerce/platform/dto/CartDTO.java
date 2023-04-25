package ecommerce.platform.dto;

import java.util.List;

public class CartDTO {
    private Long id;
    private Long customerId;
    private List<CartItemDTO> items;

    public CartDTO(){}
    public CartDTO(Long id, Long customerId, List<CartItemDTO> items) {
        this.id = id;
        this.customerId = customerId;
        this.items = items;
    }

    // getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public List<CartItemDTO> getItems() {
        return items;
    }

    public void setItems(List<CartItemDTO> items) {
        this.items = items;
    }

    public List<CartItemDTO> getCartItems() {
        return this.items;
    }

    public void setCartItems(List<CartItemDTO> cartItems) {
        this.items = cartItems;
    }
}