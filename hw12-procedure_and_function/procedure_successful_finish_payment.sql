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