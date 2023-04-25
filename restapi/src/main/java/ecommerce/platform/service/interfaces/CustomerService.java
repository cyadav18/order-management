package ecommerce.platform.service.interfaces;

import ecommerce.platform.dto.CustomerDTO;

import java.util.List;

public interface CustomerService {

    List<CustomerDTO> getAllCustomers();
    CustomerDTO getCustomerById(Long id);
    CustomerDTO createCustomer(CustomerDTO customerDto);
    CustomerDTO updateCustomer(Long id, CustomerDTO customerDto);
    void deleteCustomer(Long id);

}