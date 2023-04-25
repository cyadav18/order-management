package ecommerce.platform.mappers;

import ecommerce.platform.dto.CustomerDTO;
import ecommerce.platform.model.Customer;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class CustomerMapper {

    
    public CustomerDTO toDto(Customer customer) {
        if (customer == null) {
            return null;
        }

        CustomerDTO customerDto = new CustomerDTO();
        customerDto.setId(customer.getId());
        customerDto.setFirstName(customer.getFirstName());
        customerDto.setLastName(customer.getLastName());
        customerDto.setEmail(customer.getEmail());
        customerDto.setPasswordHash(customer.getPasswordHash());
        customerDto.setActive(customer.isActive());
        customerDto.setRegisteredAt(customer.getRegisteredAt());
        customerDto.setUpdatedAt(customer.getUpdatedAt());

        return customerDto;
    }

    
    public Customer toEntity(CustomerDTO customerDto) {
        if (customerDto == null) {
            return null;
        }

        Customer customer = new Customer();
        customer.setId(customerDto.getId());
        customer.setFirstName(customerDto.getFirstName());
        customer.setLastName(customerDto.getLastName());
        customer.setEmail(customerDto.getEmail());
        customer.setPasswordHash(customerDto.getPasswordHash());
        customer.setActive(customerDto.isActive());
        customer.setRegisteredAt(customerDto.getRegisteredAt());
        customer.setUpdatedAt(customerDto.getUpdatedAt());

        return customer;
    }

    
    public List<CustomerDTO> toDtoList(List<Customer> customers) {
        if (customers == null) {
            return null;
        }

        return customers.stream().map(this::toDto).collect(Collectors.toList());
    }

    
    public List<Customer> toEntityList(List<CustomerDTO> customerDtos) {
        if (customerDtos == null) {
            return null;
        }

        return customerDtos.stream().map(this::toEntity).collect(Collectors.toList());
    }
}
