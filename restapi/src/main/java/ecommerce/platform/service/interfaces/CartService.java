package ecommerce.platform.service.interfaces;


import ecommerce.platform.ExceptionHandler.*;
import ecommerce.platform.dto.CartDTO;
import java.math.BigDecimal;

public interface CartService {

    CartDTO getCartByCustomerId(Long customerId) throws CartNotFoundException;

    CartDTO addProductToCart(Long customerId, Long productId, int quantity) throws ProductNotFoundException, CartNotFoundException, InsufficientInventoryException;

    CartDTO removeProductFromCart(Long customerId, Long productId) throws CartNotFoundException, ProductNotFoundException;

    BigDecimal getCartPrice(Long customerId) throws CartNotFoundException;

    CartDTO createCartForCustomer(Long customerId);
}
