package ecommerce.platform.service;

import ecommerce.platform.dto.CustomerDTO;
import ecommerce.platform.mappers.CustomerMapper;
import ecommerce.platform.model.Customer;
import ecommerce.platform.repository.CustomerRepository;
import ecommerce.platform.service.interfaces.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<CustomerDTO> getAllCustomers() {
        List<Customer> customers = customerRepository.findAll();
        return customerMapper.toDtoList(customers);
    }

    @Override
    public CustomerDTO getCustomerById(Long id) {
        Customer customer = customerRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Customer not found with id " + id));
        return customerMapper.toDto(customer);
    }

    @Override
    public CustomerDTO createCustomer(CustomerDTO customerDto) {
        Customer customer = customerMapper.toEntity(customerDto);
        customer = customerRepository.save(customer);
        return customerMapper.toDto(customer);
    }

    @Override
    public CustomerDTO updateCustomer(Long id, CustomerDTO customerDto) {
        Customer customer = customerRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Customer not found with id " + id));

        // Update customer properties
        customer.setFirstName(customerDto.getFirstName());
        customer.setLastName(customerDto.getLastName());
        customer.setEmail(customerDto.getEmail());
        customer.setPasswordHash(customerDto.getPasswordHash());
        customer.setActive(customerDto.isActive());

        customer = customerRepository.save(customer);
        return customerMapper.toDto(customer);
    }

    @Override
    public void deleteCustomer(Long id) {
        Customer customer = customerRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Customer not found with id " + id));
        customerRepository.delete(customer);
    }
}
