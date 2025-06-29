create or replace trigger payment_b_d_restrict
Before delete on payment 
Begin 
   payment_api_pack.check_client_delete_restriction();
end;