package ecommerce.platform.controller;

import ecommerce.platform.ExceptionHandler.CartNotFoundException;
import ecommerce.platform.ExceptionHandler.CustomerNotFoundException;
import ecommerce.platform.ExceptionHandler.InsufficientInventoryException;
import ecommerce.platform.ExceptionHandler.ProductNotFoundException;
import ecommerce.platform.dto.CartDTO;
import ecommerce.platform.service.CartServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/carts")
public class CartController {


    private final CartServiceImpl cartServiceImpl;

    @Autowired
    public CartController(CartServiceImpl cartServiceImpl) {
        this.cartServiceImpl = cartServiceImpl;
    }

    @PostMapping("/{customerId}")
    public ResponseEntity<CartDTO> createCart(@PathVariable Long customerId) {
        try {
            CartDTO cartDTO = cartServiceImpl.createCartForCustomer(customerId);
            return ResponseEntity.ok(cartDTO);
        } catch (CustomerNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @GetMapping("/{customerId}")
    public ResponseEntity<CartDTO> getCartByCustomerId(@PathVariable Long customerId) {
        try {
            CartDTO cartDTO = cartServiceImpl.getCartByCustomerId(customerId);
            return ResponseEntity.ok(cartDTO);
        } catch (CartNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @PostMapping("/{customerId}/items/{productId}/{quantity}")
    public ResponseEntity<CartDTO> addProductToCart(@PathVariable Long customerId, @PathVariable Long productId, @PathVariable int quantity) {
        try {
            CartDTO cartDTO = cartServiceImpl.addProductToCart(customerId, productId, quantity);
            return ResponseEntity.ok(cartDTO);
        } catch (ProductNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        } catch (CartNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        } catch (InsufficientInventoryException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(null);
        }
    }

    @DeleteMapping("/{customerId}/items/{productId}")
    public ResponseEntity<CartDTO> removeProductFromCart(@PathVariable Long customerId, @PathVariable Long productId) {
        try {
            CartDTO cartDTO = cartServiceImpl.removeProductFromCart(customerId, productId);
            return ResponseEntity.ok(cartDTO);
        } catch (CartNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        } catch (ProductNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @GetMapping("/{customerId}/price")
    public ResponseEntity<?> getCartPrice(@PathVariable Long customerId) {
        try {
            BigDecimal cartPrice = cartServiceImpl.getCartPrice(customerId);
            Map<String, Object> response = new HashMap<>();
            response.put("customerId", customerId);
            response.put("cartPrice", cartPrice);
            return ResponseEntity.ok(response);
        } catch (CartNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }
}
