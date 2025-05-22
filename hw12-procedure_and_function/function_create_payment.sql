--Создание платежа
Create or replace function create_payment(p_payment_details t_payment_details_array,
p_currency_id payment.currency_id%type,
p_from_client_id payment.from_client_id%type,
p_to_client_id payment.to_client_id%type,
p_create_date payment.CREATE_DTIME%type,
p_summa payment.summa%type) return payment.payment_id%type
is
  v_message varchar2(200 char) :='Платеж создан';
  c_status_create constant payment.status%type := 0;
  v_payment_id payment.payment_id%type;
  
Begin 
    if p_payment_details is not empty then 
        for i in p_payment_details.first .. p_payment_details.last loop
            if (p_payment_details(i).field_id is null) then 
            dbms_output.put_line('ID поля не может быть пустым');
            end if;
            
            if (p_payment_details(i).field_value is null) then 
            dbms_output.put_line('Значение в поля не может быть пустым');
            end if;
            dbms_output.put_line('Failed_id: ' || p_payment_details(i).field_id || '. Value: ' || p_payment_details(i).field_value);
        end loop;
    else 
        dbms_output.put_line('Коллекция не содержит данных');
    end if;

  dbms_output.put_line(v_message || '. Статус: ' || c_status_create || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(p_create_date, '"date: "dd.mon.YYYY "time: "hh24:mi:ss'));
  
  -- Создание платжа
    Insert into Payment (PAYMENT_ID,
                        CREATE_DTIME,
                        SUMMA,
                        CURRENCY_ID,
                        FROM_CLIENT_ID,
                        TO_CLIENT_ID,
                        STATUS,
                        STATUS_CHANGE_REASON)
    values (PAYMENT_SEQ.nextval, p_create_date, p_summa, p_currency_id, 
            p_from_client_id, p_to_client_id, c_status_create, null)
    returning PAYMENT_ID into v_payment_id;
    
    dbms_output.put_line('Payment_id: ' || v_payment_id);
    
   -- Добавление данных платежа  
   insert into payment_detail 
   Select v_payment_id, value(t).field_id, value(t).field_value from table(p_payment_details) t;
    
	return v_payment_id;
end;
/