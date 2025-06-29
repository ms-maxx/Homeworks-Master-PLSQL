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

--Триггеры

-- Проверка, вызываемая из триггера
    procedure is_changes_through_api;

-- Проверка на возможность удалять данные
    procedure check_client_delete_restriction;
    
end;