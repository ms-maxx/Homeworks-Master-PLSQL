create or replace package payment_api_pack is
/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” 
*/
--Статусы платежей

	c_status_create constant payment.status%type := 0;
	c_status_error constant payment.status%type := 2;
	c_status_cancel constant payment.status%type := 3;
	c_status_end_pay_succes constant payment.status%type := 1;

--Сообщения об ошибках

	c_error_msg_empty_field_id constant varchar2(100 char) := 'ID поля не может быть пустым';
	c_error_msg_empty_field_value constant varchar2(100 char) := 'Значение в поле не может быть пустым';
	c_error_msg_empty_collection constant varchar2(100 char) := 'Коллекция не содержит данных';
	c_error_msg_empty_object_id constant varchar2(100 char) := 'ID объекта не может быть пустым';
	c_error_msg_empty_reason constant varchar2(100 char) := 'Причина не может быть пустой';
    c_error_msg_delete_forbidden constant varchar2(100 char) := 'Удаление объекта запрещено';
    c_error_msg_manual_changes constant varchar2(100 char) := 'Изменения должны выполняться только через API';

--Коды ошибок

    c_error_code_invalid_input_parameter constant number(10) := -20101;
    c_error_code_delete_forbidden constant number(10) := -20102;
    c_error_code_manual_changes constant number(10) := -20103;

--Объекты исключений
    invalid_input_parameter exception;
    pragma exception_init(invalid_input_parameter, c_error_code_invalid_input_parameter);
    invalid_delete_forbidden exception;
    pragma exception_init(invalid_delete_forbidden, c_error_code_delete_forbidden);
    invalid_manual_changes exception;
    pragma exception_init(invalid_manual_changes, c_error_code_manual_changes);

--Создание платежа

	function create_payment(p_payment_details t_payment_details_array,
p_currency_id payment.currency_id%type,
p_from_client_id payment.from_client_id%type,
p_to_client_id payment.to_client_id%type,
p_create_date payment.CREATE_DTIME%type,
p_summa payment.summa%type) return payment.payment_id%type;

--Сброс платежа

	procedure fail_payment (p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type);

--Отмена платежа

	procedure cancel_payment(p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type);

--Завершение платежа (успешно)

	procedure successful_finish_payment(p_payment_id payment.payment_id%type);

-- Проверка, вызываемая из триггера
    
    procedure is_changes_through_api;
    
end;