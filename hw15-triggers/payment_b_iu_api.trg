Create or replace trigger payment_b_iu_api
Before insert or update on payment
Begin 
    payment_api_pack.is_changes_through_api();
end;
/