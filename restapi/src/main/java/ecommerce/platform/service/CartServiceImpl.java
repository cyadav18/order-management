package ecommerce.platform.service;

import ecommerce.platform.ExceptionHandler.CartNotFoundException;
import ecommerce.platform.ExceptionHandler.InsufficientInventoryException;
import ecommerce.platform.ExceptionHandler.ProductNotFoundException;
import ecommerce.platform.dto.CartDTO;
import ecommerce.platform.mappers.CartMapper;
import ecommerce.platform.model.Cart;
import ecommerce.platform.model.CartItem;
import ecommerce.platform.model.Product;
import ecommerce.platform.repository.CartItemRepository;
import ecommerce.platform.repository.CartRepository;
import ecommerce.platform.repository.ProductRepository;
import ecommerce.platform.service.interfaces.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Optional;

@Service
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;

    private final CartItemRepository cartItemRepository;

    private final ProductRepository productRepository;

    @Autowired
    public CartServiceImpl(CartRepository cartRepository, CartItemRepository cartItemRepository, ProductRepository productRepository) {
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.productRepository = productRepository;
    }

    public CartDTO getCartByCustomerId(Long customerId) throws CartNotFoundException {
        Optional<Cart> cartOptional = cartRepository.findByCustomerId(customerId);
        Cart cart = cartOptional.orElseThrow(() -> new CartNotFoundException("Cart not found for customer with ID " + customerId));
        return CartMapper.toDTO(cart);
    }

    public CartDTO addProductToCart(Long customerId, Long productId, int quantity) throws ProductNotFoundException, CartNotFoundException, InsufficientInventoryException {
        Optional<Product> productOptional = productRepository.findById(productId);
        Product product = productOptional.orElseThrow(() -> new ProductNotFoundException("Product not found with ID " + productId));

        int productQuantity = product.getQuantity();
        if (productQuantity < quantity) {
            throw new InsufficientInventoryException("Not enough inventory for product with ID " + productId);
        }

        Optional<Cart> cartOptional = cartRepository.findByCustomerId(customerId);
        Cart cart;
        if (cartOptional.isPresent()) {
            cart = cartOptional.get();
        } else {
            cart = new Cart();
            cart.setCustomerId(customerId);
        }

        Optional<CartItem> cartItemOptional = cartItemRepository.findByCartIdAndProductId(cart.getId(), productId);
        CartItem cartItem;
        if (cartItemOptional.isPresent()) {
            cartItem = cartItemOptional.get();
            if (cartItem.getQuantity()+quantity > productQuantity){
                throw new InsufficientInventoryException("Not enough inventory for product with ID " + productId);
            }
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
        } else {
            cartItem = new CartItem();
            cartItem.setCart(cart);
            cartItem.setProduct(product);
            cartItem.setQuantity(quantity);
        }

        cartItemRepository.save(cartItem);
        cartRepository.save(cart);

        return CartMapper.toDTO(cart);
    }

    public CartDTO removeProductFromCart(Long customerId, Long productId) throws CartNotFoundException, ProductNotFoundException {
        Optional<Cart> cartOptional = cartRepository.findByCustomerId(customerId);
        Cart cart = cartOptional.orElseThrow(() -> new CartNotFoundException("Cart not found for customer with ID " + customerId));

        Optional<CartItem> cartItemOptional = cartItemRepository.findByCartIdAndProductId(cart.getId(), productId);
        CartItem cartItem = cartItemOptional.orElseThrow(() -> new ProductNotFoundException("Product not found in cart for customer with ID " + customerId));

        cartItemRepository.delete(cartItem);
        cartRepository.save(cart);

        return CartMapper.toDTO(cart);
    }

    public BigDecimal getCartPrice(Long customerId) throws CartNotFoundException {
        Optional<Cart> cartOptional = cartRepository.findByCustomerId(customerId);
        Cart cart = cartOptional.orElseThrow(() -> new CartNotFoundException("Cart not found for customer with ID " + customerId));

        BigDecimal totalCartPrice = BigDecimal.ZERO;
        for (CartItem cartItem : cart.getCartItems()) {
            BigDecimal productPrice = cartItem.getProduct().getSalePrice();
            int quantity = cartItem.getQuantity();
            BigDecimal cartItemPrice = productPrice.multiply(BigDecimal.valueOf(quantity));
            totalCartPrice = totalCartPrice.add(cartItemPrice);
        }

        return totalCartPrice;
    }

    public CartDTO createCartForCustomer(Long customerId) {
        Cart cart = new Cart();
        cart.setCustomerId(customerId);
        cart = cartRepository.save(cart);
        return CartMapper.toDTO(cart);
    }
}
