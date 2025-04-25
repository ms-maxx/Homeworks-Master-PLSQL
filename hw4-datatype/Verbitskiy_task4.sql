set serveroutput on;

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

--Создание платежа
Declare 
  v_message varchar2(200 char) :='Платеж создан';
  c_status_create constant number(10) := 0;
  v_current_date date := sysdate; 
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_create);
  dbms_output.put_line(to_char(v_current_date, '"date: "dd.mon.YYYY "time: "hh24:mi:ss'));
end;
/
--Сброс платежа
Declare 
  v_message varchar2(200 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  c_status_error constant number(10) := 2;
  v_reason varchar2(200 char) :=  'недостаточно средств';
  v_current_date timestamp := systimestamp;
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_error || '. Причина: ' || v_reason);
  dbms_output.put_line(to_char(v_current_date, 'DDsp MMsp YYYYsp hh24:ss:mi:ff5'));
end;
/
--Отмена платежа
Declare 
  v_message varchar2(200 char) := 'Отмена платежа с указанием причины';
  c_status_cancel constant number(10) := 3;
  v_reason varchar2(200 char) :=  'ошибка пользователя';
  v_current_date timestamp := systimestamp;
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_cancel || '. Причина: ' || v_reason);
  dbms_output.put_line(to_char(v_current_date, 'dd.mm.YY hh24:ss:mi:ff5 "century: "CC'));
end;
/
--Завершение платежа (успешно)
Declare 
  v_message varchar2(200 char) := 'Успешное завершение платежа';
  c_status_end_pay_succes constant number(10) := 1;
  v_current_date date := sysdate; 
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_end_pay_succes);
  dbms_output.put_line(to_char(v_current_date, 'ddth "of" fmmonth "year:" fmYYYY "time: " fmhh24:mi:ss'));
end;
/
--Добавление/обновление данных платежа
Declare 
v_message varchar2(200 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
v_current_date date := sysdate; 
Begin 
  dbms_output.put_line(v_message);
  dbms_output.put_line(to_char(v_current_date, 'dd/mon/YYYY d.w.q'));
end;
/
--Удаление платежа
Declare 
v_message varchar2(200 char) := 'Детали платежа удалены по списку id_полей';
v_current_date timestamp := systimestamp;
Begin 
  dbms_output.put_line(v_message);
  dbms_output.put_line(to_char(v_current_date, 'dy MM YYYY hh12:ss:mi:ff5'));
end;
/