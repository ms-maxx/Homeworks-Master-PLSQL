set serveroutput on;

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

--Создание платежа
Declare 
  v_message varchar2(200 char) :='Платеж создан';
  c_status_create constant payment.status%type := 0;
  v_current_date date := sysdate; 
  v_payment_id payment.payment_id%type;
  v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'CLIENT_SOFTWARE'),
                                                                    t_payment_detail(2, 'IP'),
                                                                    t_payment_detail(3, 'NOTE'),
                                                                    t_payment_detail(4, 'IS_CHECKED_FRAUD'));
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_create || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, '"date: "dd.mon.YYYY "time: "hh24:mi:ss'));
end;
/
--Сброс платежа
Declare 
  v_message varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  c_status_error constant payment.status%type := 2;
  v_reason payment.status_change_reason%type :=  'недостаточно средств';
  v_current_date timestamp := systimestamp;
  v_payment_id payment.payment_id%type;
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
    
    if v_reason is null 
    then dbms_output.put_line('Причина не может быть пустой');
    end if;
    
  dbms_output.put_line(v_message || '. Статус: ' || c_status_error || '. Причина: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'DDsp MMsp YYYYsp hh24:ss:mi:ff5'));
end;
/
--Отмена платежа
Declare 
  v_message varchar2(200 char) := 'Отмена платежа с указанием причины';
  c_status_cancel constant payment.status%type := 3;
  v_reason payment.status_change_reason%type :=  'ошибка пользователя';
  v_current_date timestamp := systimestamp;
  v_payment_id payment.payment_id%type;
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
    
    if v_reason is null 
    then dbms_output.put_line('Причина не может быть пустой');
    end if;

  dbms_output.put_line(v_message || '. Статус: ' || c_status_cancel || '. Причина: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'dd.mm.YY hh24:ss:mi:ff5 "century: "CC'));
end;
/
--Завершение платежа (успешно)
Declare 
  v_message varchar2(200 char) := 'Успешное завершение платежа';
  c_status_end_pay_succes constant payment.status_change_reason%type := 1;
  v_current_date date := sysdate; 
  v_payment_id payment.payment_id%type;
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
           
  dbms_output.put_line(v_message || '. Статус: ' || c_status_end_pay_succes || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'ddth "of" fmmonth "year:" fmYYYY "time: " fmhh24:mi:ss'));
end;
/
--Добавление/обновление данных платежа
Declare 
v_message varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
v_current_date date := sysdate; 
v_payment_id payment.payment_id%type;
v_payment_detail t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'CLIENT_SOFTWARE'),
                                                                    t_payment_detail(2, 'IP'),
                                                                    t_payment_detail(3, 'NOTE'),
                                                                    t_payment_detail(4, 'IS_CHECKED_FRAUD'));
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
    
  dbms_output.put_line(v_message || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'dd/mon/YYYY d.w.q'));
end;
/
--Удаление платежа
Declare 
v_message varchar2(200 char) := 'Детали платежа удалены по списку id_полей';
v_current_date timestamp := systimestamp;
v_payment_id payment.payment_id%type;
v_delete_payment t_number_array :=t_number_array(1,2,3);
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID объекта не может быть пустым');
    end if;
    
    dbms_output.put_line(v_message || '. ID: ' || v_payment_id);
    dbms_output.put_line(to_char(v_current_date, 'dy MM YYYY hh12:ss:mi:ff5'));
end;
/