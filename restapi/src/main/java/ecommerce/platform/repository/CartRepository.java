package ecommerce.platform.repository;

import ecommerce.platform.model.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {

    //By using findByCustomerId ,
    // we are instructing Spring Data to create a query based on the customer attribute and its id field.

    Optional<Cart> findByCustomerId(Long id);

}
