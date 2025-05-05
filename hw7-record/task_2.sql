
declare 
    v_rec PAYMENT_DETAIL_FIELD%rowtype;
Begin 
 Select * into v_rec from PAYMENT_DETAIL_FIELD where FIELD_ID = 1;
 
 dbms_output.put_line('FIELD_ID: '|| v_rec.FIELD_ID || ' ' ||
                        'NAME: ' || v_rec.NAME || ' ' ||
                        'DESCRIPTION: ' || v_rec.DESCRIPTION);
end;
/