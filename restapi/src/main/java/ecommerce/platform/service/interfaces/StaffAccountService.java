package ecommerce.platform.service.interfaces;


import ecommerce.platform.model.StaffAccount;

import java.util.List;
import java.util.Optional;

public interface StaffAccountService {

    List<StaffAccount> getAllStaffAccounts();

    Optional<StaffAccount> getStaffAccountById(int id);

    StaffAccount createStaffAccount(StaffAccount staffAccount);

    StaffAccount updateStaffAccount(int id, StaffAccount staffAccount);

    void deleteStaffAccount(int id);

}
