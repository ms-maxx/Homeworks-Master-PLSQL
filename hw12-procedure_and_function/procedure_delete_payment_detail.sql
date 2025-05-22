--Удаление платежа
Create or replace procedure delete_payment_detail(p_payment_id PAYMENT_DETAIL.payment_id%type, 
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