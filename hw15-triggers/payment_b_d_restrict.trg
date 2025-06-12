Create or replace trigger payment_b_d_restrict
Before delete on payment 
Begin 
    raise_application_error(payment_api_pack.c_error_code_delete_forbidden, payment_api_pack.c_error_msg_delete_forbidden);
end;
/