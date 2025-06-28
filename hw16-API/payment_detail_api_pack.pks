create or replace package payment_detail_api_pack is

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Детали платежа”
*/


--Добавление/обновление данных платежа

	procedure insert_or_update_payment_detail(p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_payment_details t_payment_details_array);

--Удаление платежа

	procedure delete_payment_detail (p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_delete_field_pay t_numbers_array);

-- Проверка, вызываемая из триггера
    
    procedure is_changes_through_api;

end;