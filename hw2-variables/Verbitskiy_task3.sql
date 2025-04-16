set serveroutput on;

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

--Создание платежа
Declare 
  v_massage varchar2(50) :='Платеж создан';
  c_status constant number := 0;
Begin 
  dbms_output.put_line(v_massage || '. Статус: ' || c_status);
end;
/
--Сброс платежа
Declare 
  v_massage varchar2(100) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  c_status constant number := 2;
  v_reason varchar2(50) :=  'недостаточно средств';
Begin 
  dbms_output.put_line(v_massage || '. Статус: ' || c_status || '. Причина: ' || v_reason);
end;
/
--Отмена платежа
Declare 
  v_massage varchar2(100) := 'Отмена платежа с указанием причины';
  c_status constant number := 3;
  v_reason varchar2(50) :=  'ошибка пользователя';
Begin 
  dbms_output.put_line(v_massage || '. Статус: ' || c_status || '. Причина: ' || v_reason);
end;
/
--Завершение платежа (успешно)
Declare 
  v_massage_end_payment varchar2(100) := 'Успешное завершение платежа';
  c_status constant number := 1;
Begin 
  dbms_output.put_line(v_massage_end_payment || '. Статус: ' || c_status);
end;
/
--Добавление/обновление данных платежа
Declare 
v_massage_add_paymant varchar2(150) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
Begin 
  dbms_output.put_line(v_massage_add_paymant);
end;
/
--Удаление платежа
Declare 
v_massage_drop_paymant varchar2(100) := 'Детали платежа удалены по списку id_полей';
Begin 
  dbms_output.put_line(v_massage_drop_paymant);
end;
/