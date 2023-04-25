package ecommerce.platform.mappers;

import ecommerce.platform.dto.CartDTO;
import ecommerce.platform.dto.CartItemDTO;
import ecommerce.platform.model.Cart;
import ecommerce.platform.model.CartItem;
import ecommerce.platform.model.Product;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class CartMapper {

    public static CartDTO toDTO(Cart cart) {
        if (cart == null) {
            return null;
        }
        CartDTO cartDTO = new CartDTO();
        cartDTO.setId(cart.getId());
        cartDTO.setCustomerId(cart.getCustomerId());
        List<CartItemDTO> cartItemDTOs = new ArrayList<>();
        for (CartItem cartItem : cart.getCartItems()) {
            CartItemDTO cartItemDTO = toDTO(cartItem);
            cartItemDTOs.add(cartItemDTO);
        }
        cartDTO.setCartItems(cartItemDTOs);
        return cartDTO;
    }

    public static Cart toEntity(CartDTO cartDTO, List<Product> products) {
        if (cartDTO == null) {
            return null;
        }
        Cart cart = new Cart();
        cart.setId(cartDTO.getId());
        cart.setCustomerId(cartDTO.getCustomerId());
        List<CartItem> cartItems = new ArrayList<>();
        for (CartItemDTO cartItemDTO : cartDTO.getCartItems()) {
            Product product = products.stream()
                    .filter(p -> p.getId().equals(cartItemDTO.getProductId()))
                    .findFirst()
                    .orElse(null);
            CartItem cartItem = toEntity(cartItemDTO, cart, product);
            cartItems.add(cartItem);
        }
        cart.setCartItems(cartItems);
        return cart;
    }


    public static CartItemDTO toDTO(CartItem cartItem) {
        if (cartItem == null) {
            return null;
        }
        CartItemDTO cartItemDTO = new CartItemDTO();
        cartItemDTO.setId(cartItem.getId());
        cartItemDTO.setCartId(cartItem.getCart().getId()); // Use getCart().getId() instead of getCartId()
        cartItemDTO.setProductId(cartItem.getProduct().getId()); // Use getProduct().getId() instead of getProductId()
        cartItemDTO.setQuantity(cartItem.getQuantity());
        return cartItemDTO;
    }


    public static CartItem toEntity(CartItemDTO cartItemDTO, Cart cart, Product product) {
        if (cartItemDTO == null) {
            return null;
        }
        CartItem cartItem = new CartItem();
        cartItem.setId(cartItemDTO.getId());
        cartItem.setCart(cart);
        cartItem.setProduct(product);
        cartItem.setQuantity(cartItemDTO.getQuantity());
        return cartItem;
    }
}