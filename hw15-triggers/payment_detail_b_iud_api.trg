Create or replace trigger payment_detail_b_iud_api
Before insert or update or delete on payment_detail
Begin 
    payment_detail_api_pack.is_changes_through_api();
end;
/