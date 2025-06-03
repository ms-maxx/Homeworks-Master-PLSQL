Create or replace package body payment_api_pack is

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” 
*/

--Создание платежа

	function create_payment(p_payment_details t_payment_details_array,
p_currency_id payment.currency_id%type,
p_from_client_id payment.from_client_id%type,
p_to_client_id payment.to_client_id%type,
p_create_date payment.CREATE_DTIME%type,
p_summa payment.summa%type) return payment.payment_id%type
is
  v_message varchar2(200 char) :='Платеж создан';
  v_payment_id payment.payment_id%type;
  
Begin 
    if p_payment_details is not empty then 
        for i in p_payment_details.first .. p_payment_details.last loop
            if (p_payment_details(i).field_id is null) then 
            raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_field_id);
            end if;
            
            if (p_payment_details(i).field_value is null) then 
            raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_field_value);
            end if;
            dbms_output.put_line('Failed_id: ' || p_payment_details(i).field_id || '. Value: ' || p_payment_details(i).field_value);
        end loop;
    else 
       raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_collection);
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


--Сброс платежа

	procedure fail_payment (p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type) 
is 
  v_message varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  v_current_date timestamp := systimestamp;
Begin 
    if p_payment_id is null 
    then raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_object_id);
    end if;
    
    if p_reason is null 
    then raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_reason);
    end if;
    
  dbms_output.put_line(v_message || '. Статус: ' || c_status_error || '. Причина: ' || p_reason || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'DDsp MMsp YYYYsp hh24:ss:mi:ff5'));
  
  -- Обновление платежа 
  
    Update Payment p1
    set p1.status = c_status_error,
        p1.status_change_reason = p_reason
    where p1.status = c_status_create 
    and p1.payment_id = p_payment_id;
end;


--Отмена платежа

	procedure cancel_payment(p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type)
is
  v_message varchar2(200 char) := 'Отмена платежа с указанием причины';
  v_current_date timestamp := systimestamp;
Begin 
    if p_payment_id is null 
    then raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_object_id);
    end if;
    
    if p_reason is null 
    then raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_reason);
    end if;

  dbms_output.put_line(v_message || '. Статус: ' || c_status_cancel || '. Причина: ' || p_reason || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'dd.mm.YY hh24:ss:mi:ff5 "century: "CC'));
  
  -- Обновление платежа 
  
    Update Payment p1
    set p1.status = c_status_cancel,
        p1.status_change_reason = p_reason
    where p1.status = c_status_create
    and p1.payment_id = p_payment_id;
end;


--Завершение платежа (успешно)

	procedure successful_finish_payment(p_payment_id payment.payment_id%type)
is 
  v_message varchar2(200 char) := 'Успешное завершение платежа';
  v_current_date date := sysdate; 
Begin 
    if p_payment_id is null 
    then raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_object_id);
    end if;
           
  dbms_output.put_line(v_message || '. Статус: ' || c_status_end_pay_succes || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'ddth "of" fmmonth "year:" fmYYYY "time: " fmhh24:mi:ss'));
  
  -- Обновление платежа 
  
    Update Payment p1
    set p1.status = c_status_end_pay_succes,
        p1.status_change_reason = null
    where p1.status = c_status_create
    and p1.payment_id = p_payment_id;
end;

end payment_api_pack;
/


