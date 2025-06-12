Create or replace trigger payment_b_iu_tech_fields
    before insert or update on payment 
    for each row
Declare 
    v_current_timestamp payment.CREATE_DTIME_TECH%type := systimestamp;
Begin 
    if inserting then 
    :new.create_dtime_tech := v_current_timestamp;
    end if;
    
    :new.update_dtime_tech := v_current_timestamp;
end;
/