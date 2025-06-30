CREATE OR REPLACE PACKAGE BODY payment_detail_api_pack IS

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Детали платежа”
*/
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
    
--Добавление/обновление данных платежа

    PROCEDURE insert_or_update_payment_detail (
        p_payment_id      payment_detail.payment_id%TYPE,
        p_payment_details t_payment_details_array
    ) IS
    BEGIN
        IF p_payment_details IS NOT EMPTY THEN
            FOR i IN p_payment_details.first..p_payment_details.last LOOP
                IF ( p_payment_details(i).field_id IS NULL ) THEN
                    raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_field_id)
                    ;
                END IF;

                IF ( p_payment_details(i).field_value IS NULL ) THEN
                    raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_field_value
                    );
                END IF;

            END LOOP;
        ELSE
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_collection);
        END IF;

        payment_api_pack.try_lock_payment(p_payment_id => p_payment_id); --блокируем платеж

        allow_changes();
        MERGE INTO payment_detail p1
        USING (
            SELECT
                p_payment_id         payment_id,
                value(t).field_id    field_id,
                value(t).field_value field_value
            FROM
                TABLE ( p_payment_details ) t
        ) pd ON ( p1.payment_id = pd.payment_id
                  AND p1.field_id = pd.field_id )
        WHEN MATCHED THEN UPDATE
        SET p1.field_value = pd.field_value
        WHEN NOT MATCHED THEN
        INSERT (
            payment_id,
            field_id,
            field_value )
        VALUES
            ( pd.payment_id,
              pd.field_id,
              pd.field_value );

        disallow_changes();
    EXCEPTION
        WHEN OTHERS THEN
            disallow_changes();
            RAISE;
    END;


--Удаление платежа

    PROCEDURE delete_payment_detail (
        p_payment_id       payment_detail.payment_id%TYPE,
        p_delete_field_pay t_numbers_array
    ) IS
    BEGIN
        IF p_payment_id IS NULL THEN
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
        END IF;

        IF p_delete_field_pay IS NULL OR p_delete_field_pay IS EMPTY THEN
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_collection);
        END IF;

        payment_api_pack.try_lock_payment(p_payment_id => p_payment_id); --блокируем платеж

        allow_changes();
        DELETE FROM payment_detail p1
        WHERE
                p1.payment_id = p_payment_id
            AND p1.field_id IN (
                SELECT
                    value(t)
                FROM
                    TABLE ( p_delete_field_pay ) t
            );

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

END payment_detail_api_pack;