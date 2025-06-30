CREATE OR REPLACE PACKAGE BODY payment_api_pack IS

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” 
*/

--Создание платежа

    g_is_api BOOLEAN := FALSE; -- Признак выполенения через API
    
    --Разрешение изменять данные
    PROCEDURE allow_changes IS
    BEGIN
        g_is_api := TRUE;
    END;
    
    --Запрет на изменения данных
    PROCEDURE disallow_changes IS
    BEGIN
        g_is_api := FALSE;
    END;

    FUNCTION create_payment (
        p_payment_details t_payment_details_array,
        p_currency_id     payment.currency_id%TYPE,
        p_from_client_id  payment.from_client_id%TYPE,
        p_to_client_id    payment.to_client_id%TYPE,
        p_create_date     payment.create_dtime%TYPE,
        p_summa           payment.summa%TYPE
    ) RETURN payment.payment_id%TYPE IS
        v_payment_id payment.payment_id%TYPE;
    BEGIN   
  -- Создание платжа
        allow_changes();
        INSERT INTO payment (
            payment_id,
            create_dtime,
            summa,
            currency_id,
            from_client_id,
            to_client_id,
            status,
            status_change_reason
        ) VALUES (
            payment_seq.NEXTVAL,
            p_create_date,
            p_summa,
            p_currency_id,
            p_from_client_id,
            p_to_client_id,
            c_status_create,
            NULL
        ) RETURNING payment_id INTO v_payment_id;
    
   -- Добавление данных платежа
        payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id, p_payment_details => p_payment_details)
        ;
        disallow_changes();
        RETURN v_payment_id;
    EXCEPTION
        WHEN OTHERS THEN
            disallow_changes();
            RAISE;
    END;


--Сброс платежа

    PROCEDURE fail_payment (
        p_payment_id payment.payment_id%TYPE,
        p_reason     payment.status_change_reason%TYPE
    ) IS
    BEGIN
        IF p_payment_id IS NULL THEN
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
        END IF;

        IF p_reason IS NULL THEN
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_reason);
        END IF;

  -- Обновление платежа 
        try_lock_payment(p_payment_id => p_payment_id); --блокируем платеж

        allow_changes();
        UPDATE payment p1
        SET
            p1.status = c_status_error,
            p1.status_change_reason = p_reason
        WHERE
                p1.status = c_status_create
            AND p1.payment_id = p_payment_id;

        disallow_changes();
    EXCEPTION
        WHEN OTHERS THEN
            disallow_changes();
            RAISE;
    END;


--Отмена платежа

    PROCEDURE cancel_payment (
        p_payment_id payment.payment_id%TYPE,
        p_reason     payment.status_change_reason%TYPE
    ) IS
    BEGIN
        IF p_payment_id IS NULL THEN
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
        END IF;

        IF p_reason IS NULL THEN
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_reason);
        END IF;

  -- Обновление платежа 
        try_lock_payment(p_payment_id => p_payment_id); --блокируем платеж

        allow_changes();
        UPDATE payment p1
        SET
            p1.status = c_status_cancel,
            p1.status_change_reason = p_reason
        WHERE
                p1.status = c_status_create
            AND p1.payment_id = p_payment_id;

        disallow_changes();
    EXCEPTION
        WHEN OTHERS THEN
            disallow_changes();
            RAISE;
    END;


--Завершение платежа (успешно)

    PROCEDURE successful_finish_payment (
        p_payment_id payment.payment_id%TYPE
    ) IS
    BEGIN
        IF p_payment_id IS NULL THEN
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
        END IF;

  -- Обновление платежа 
        try_lock_payment(p_payment_id => p_payment_id); --блокируем платеж

        allow_changes();
        UPDATE payment p1
        SET
            p1.status = c_status_end_pay_succes,
            p1.status_change_reason = NULL
        WHERE
                p1.status = c_status_create
            AND p1.payment_id = p_payment_id;

        disallow_changes();
    EXCEPTION
        WHEN OTHERS THEN
            disallow_changes();
            RAISE;
    END;

    PROCEDURE is_changes_through_api IS
    BEGIN
        IF
            NOT g_is_api
            AND NOT common_pack.is_manual_changes_allowed()
        THEN
            raise_application_error(common_pack.c_error_code_manual_changes, common_pack.c_error_msg_manual_changes);
        END IF;
    END;

    PROCEDURE check_client_delete_restriction IS
    BEGIN
        IF NOT common_pack.is_manual_changes_allowed() THEN
            raise_application_error(common_pack.c_error_code_delete_forbidden, common_pack.c_error_msg_delete_forbidden);
        END IF;
    END;

    PROCEDURE try_lock_payment (
        p_payment_id payment.payment_id%TYPE
    ) IS
        v_status payment.status%TYPE;
    BEGIN
        SELECT
            t.status
        INTO v_status
        FROM
            payment t
        WHERE
            t.payment_id = p_payment_id
        FOR UPDATE NOWAIT;

        IF v_status IN ( 1, 2, 3 ) THEN
            raise_application_error(common_pack.c_error_code_infinal_object, common_pack.c_error_msg_infinal_object);
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(common_pack.c_error_code_object_notfound, common_pack.c_error_msg_object_notfound);
        WHEN common_pack.invalid_row_locked THEN
            raise_application_error(common_pack.c_error_code_object_already_locked, common_pack.c_error_msg_object_already_locked);
    END;

END payment_api_pack;