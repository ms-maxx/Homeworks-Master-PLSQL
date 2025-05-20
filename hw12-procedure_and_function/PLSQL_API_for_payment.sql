set serveroutput on;

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

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

--Сброс платежа
Create or replace procedure fail_payment (p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type) 
is 
  v_message varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  c_status_error constant payment.status%type := 2;
  v_current_date payment.CREATE_DTIME%type := systimestamp;
  c_status_create constant payment.status%type := 0;
Begin 
    if p_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
    
    if p_reason is null 
    then dbms_output.put_line('Причина не может быть пустой');
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
/

--Отмена платежа
Create or replace procedure cancel_payment(p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type)
is
  v_message varchar2(200 char) := 'Отмена платежа с указанием причины';
  c_status_cancel constant payment.status%type := 3;
  v_current_date payment.CREATE_DTIME%type := systimestamp;
  c_status_create constant payment.status%type := 0;
Begin 
    if p_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
    
    if p_reason is null 
    then dbms_output.put_line('Причина не может быть пустой');
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
/

--Завершение платежа (успешно)
Create or replace procedure successful_finish_payment(p_payment_id payment.payment_id%type)
is 
  v_message varchar2(200 char) := 'Успешное завершение платежа';
  c_status_end_pay_succes constant payment.status%type := 1;
  v_current_date payment.CREATE_DTIME%type:= sysdate; 
  c_status_create constant payment.status%type := 0;
Begin 
    if p_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
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
/

--Добавление/обновление данных платежа
Create or replace procedure insert_or_update_payment_detail(p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_payment_details t_payment_details_array)
is
v_message varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
v_current_date payment.CREATE_DTIME%type:= sysdate;
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
	
	dbms_output.put_line(v_message || '. ID: ' || p_payment_id);
    dbms_output.put_line(to_char(v_current_date, 'dd/mon/YYYY d.w.q'));
    
  Merge into PAYMENT_DETAIL p1
  using (Select p_payment_id payment_id,
                value(t).field_id field_id,
                value(t).field_value field_value
        From table(p_payment_details) t) pd
        on (p1.payment_id = pd.payment_id and p1.field_id = pd.field_id)
        when matched then 
        Update set
        p1.field_value = pd.field_value
        when not matched then 
        insert (payment_id, field_id, field_value)
        values (pd.payment_id, pd.field_id, pd.field_value);
end;
/

--Удаление платежа
Create or replace procedure delete_payment_detail (p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_delete_field_pay t_numbers_array)
is 
v_message varchar2(200 char) := 'Детали платежа удалены по списку id_полей';
v_current_date payment.CREATE_DTIME%type := systimestamp;
Begin  
    if p_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
    
     if p_delete_field_pay is empty then 
        dbms_output.put_line('Коллекция не содержит данных');
    end if;
    
    Delete from PAYMENT_DETAIL p1
    where p1.payment_id = p_payment_id
    and p1.field_id in (Select value(t) from table(p_delete_field_pay) t);
	
	dbms_output.put_line(v_message || '. ID: ' || p_payment_id);
    dbms_output.put_line(to_char(v_current_date, 'dy MM YYYY hh12:ss:mi:ff5'));
    dbms_output.put_line('Количество удаляемых полей: ' || p_delete_field_pay.count());
end;
/

select t.status
           ,t.*
  from user_objects t
 where t.object_type in ('FUNCTION', 'PROCEDURE');


