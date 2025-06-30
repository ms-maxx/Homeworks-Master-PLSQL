CREATE OR REPLACE PACKAGE payment_api_pack IS
/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” 
*/


--Статусы платежей

    c_status_create CONSTANT payment.status%TYPE := 0;
    c_status_error CONSTANT payment.status%TYPE := 2;
    c_status_cancel CONSTANT payment.status%TYPE := 3;
    c_status_end_pay_succes CONSTANT payment.status%TYPE := 1;


--Создание платежа

    FUNCTION create_payment (
        p_payment_details t_payment_details_array,
        p_currency_id     payment.currency_id%TYPE,
        p_from_client_id  payment.from_client_id%TYPE,
        p_to_client_id    payment.to_client_id%TYPE,
        p_create_date     payment.create_dtime%TYPE,
        p_summa           payment.summa%TYPE
    ) RETURN payment.payment_id%TYPE;

--Сброс платежа

    PROCEDURE fail_payment (
        p_payment_id payment.payment_id%TYPE,
        p_reason     payment.status_change_reason%TYPE
    );

--Отмена платежа

    PROCEDURE cancel_payment (
        p_payment_id payment.payment_id%TYPE,
        p_reason     payment.status_change_reason%TYPE
    );

--Завершение платежа (успешно)

    PROCEDURE successful_finish_payment (
        p_payment_id payment.payment_id%TYPE
    );
    
--Блокировка платежа для изменений

    PROCEDURE try_lock_payment (
        p_payment_id payment.payment_id%TYPE
    );

--Триггеры

-- Проверка, вызываемая из триггера

    PROCEDURE is_changes_through_api;

-- Проверка на возможность удалять данные
    PROCEDURE check_client_delete_restriction;

END;