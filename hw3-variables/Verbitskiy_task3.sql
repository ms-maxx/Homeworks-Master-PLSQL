
/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

--Создание платежа
Declare 
  v_message varchar2(50) :='Платеж создан';
  c_status_create constant number := 0;
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_create);
end;
/
--Сброс платежа
Declare 
  v_message varchar2(100 char) := 'Сброс платежа в "ошибочный статус" с указанием причины';
  c_status_error constant number := 2;
  v_reason varchar2(50) :=  'недостаточно средств';
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_error || '. Причина: ' || v_reason);
end;
/
--Отмена платежа
Declare 
  v_message varchar2(100) := 'Отмена платежа с указанием причины';
  c_status_cancel constant number := 3;
  v_reason varchar2(50) :=  'ошибка пользователя';
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_cancel || '. Причина: ' || v_reason);
end;
/
--Завершение платежа (успешно)
Declare 
  v_message varchar2(100) := 'Успешное завершение платежа';
  c_status_end_pay_succes constant number := 1;
Begin 
  dbms_output.put_line(v_message || '. Статус: ' || c_status_end_pay_succes);
end;
/
--Добавление/обновление данных платежа
Declare 
v_message varchar2(150) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
Begin 
  dbms_output.put_line(v_message);
end;
/
--Удаление платежа
Declare 
v_message varchar2(100) := 'Детали платежа удалены по списку id_полей';
Begin 
  dbms_output.put_line(v_message);
end;
/