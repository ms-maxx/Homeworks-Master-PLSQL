--Проверка "Создания платежа"

DECLARE
    v_payment_details   t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'CLIENT_SOFTWARE'), t_payment_detail(2
    , 'IP'), t_payment_detail(3, 'NOTE'), t_payment_detail(4, 'IS_CHECKED_FRAUD'));
    v_payment_id        payment.payment_id%TYPE;
    v_create_dtime_tech payment.create_dtime_tech%TYPE;
    v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
    v_payment_id := payment_api_pack.create_payment(v_payment_details, p_currency_id => 840, p_from_client_id => 1, p_to_client_id => 2
    , p_create_date => sysdate,
                                                   p_summa => 6000);

    dbms_output.put_line('Payment ID:' || v_payment_id);
    SELECT
        p.create_dtime_tech,
        p.update_dtime_tech
    INTO
        v_create_dtime_tech,
        v_update_dtime_tech
    FROM
        payment p
    WHERE
        p.payment_id = v_payment_id;

    IF v_create_dtime_tech != v_update_dtime_tech THEN
        raise_application_error(-20998, 'Технические даты разные!');
    END IF;
END;
/

--Проверка "Сброс статуса платежа"

DECLARE
    v_payment_id        payment.payment_id%TYPE := 109;
    v_reason            payment.status_change_reason%TYPE := 'Тестовый сброс платежа';
    v_create_dtime_tech payment.create_dtime_tech%TYPE;
    v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
    payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    SELECT
        p.create_dtime_tech,
        p.update_dtime_tech
    INTO
        v_create_dtime_tech,
        v_update_dtime_tech
    FROM
        payment p
    WHERE
        p.payment_id = v_payment_id;

    IF v_create_dtime_tech = v_update_dtime_tech THEN
        raise_application_error(-20998, 'Технические даты равны!');
    END IF;
END;
/

--Проверка "Отмена платежа"		

DECLARE
    v_payment_id        payment.payment_id%TYPE := 109;
    v_reason            payment.status_change_reason%TYPE := 'Тестовая отмена платежа';
    v_create_dtime_tech payment.create_dtime_tech%TYPE;
    v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
    payment_api_pack.cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    SELECT
        p.create_dtime_tech,
        p.update_dtime_tech
    INTO
        v_create_dtime_tech,
        v_update_dtime_tech
    FROM
        payment p
    WHERE
        p.payment_id = v_payment_id;

    IF v_create_dtime_tech = v_update_dtime_tech THEN
        raise_application_error(-20998, 'Технические даты равны!');
    END IF;
END;
/

--Проверка "Завершение платежа (успешно)"

DECLARE
    v_payment_id        payment.payment_id%TYPE := 109;
    v_create_dtime_tech payment.create_dtime_tech%TYPE;
    v_update_dtime_tech payment.update_dtime_tech%TYPE;
BEGIN
    payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
    SELECT
        p.create_dtime_tech,
        p.update_dtime_tech
    INTO
        v_create_dtime_tech,
        v_update_dtime_tech
    FROM
        payment p
    WHERE
        p.payment_id = v_payment_id;

    IF v_create_dtime_tech = v_update_dtime_tech THEN
        raise_application_error(-20998, 'Технические даты равны!');
    END IF;
END;
/

--Проверка "Добавление/обновление данных платежа"

DECLARE
    v_payment_details t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'windows'), t_payment_detail(2, '172.19.45.79'
    ), t_payment_detail(3, 'mail_3@com'), t_payment_detail(4, 'mail_4@com'));
    v_payment_id      payment.payment_id%TYPE := 29;
BEGIN
    payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id, p_payment_details => v_payment_details);
END;
/

--Проверка "Удаление платежа"

DECLARE
    v_delete_field_pay t_numbers_array := t_numbers_array(1, 3);
    v_payment_id       payment.payment_id%TYPE := 110;
BEGIN
    payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, p_delete_field_pay => v_delete_field_pay);
END;
/

--Проверка функционала по глобальному отключению проверок. 

    --Операция уаление платежа

DECLARE
    v_payment_id payment.payment_id%TYPE := -1;
BEGIN
    common_pack.enable_manual_changes();
    DELETE FROM payment p
    WHERE
        p.payment_id = v_payment_id;

    common_pack.disable_manual_changes();
EXCEPTION
    WHEN OTHERS THEN
        common_pack.disable_manual_changes();
        RAISE;
END;
/

    --Операция обновления платежа

DECLARE
    v_payment_id payment.payment_id%TYPE := -1;
BEGIN
    common_pack.enable_manual_changes();
    UPDATE payment p1
    SET
        p1.status = payment_api_pack.c_status_error
    WHERE
            p1.status = 0
        AND p1.payment_id = v_payment_id;

    common_pack.disable_manual_changes();
EXCEPTION
    WHEN OTHERS THEN
        common_pack.disable_manual_changes();
        RAISE;
END;
/ 

    --Операция обновления деталей платежа

DECLARE
    v_payment_id payment.payment_id%TYPE := -1;
BEGIN
    common_pack.enable_manual_changes();
    UPDATE payment_detail
    SET
        field_id = field_id
    WHERE
        payment_id = v_payment_id;

    common_pack.disable_manual_changes();
EXCEPTION
    WHEN OTHERS THEN
        common_pack.disable_manual_changes();
        RAISE;
END;
/  

-- Негативные Unit-тесты

    -- Проверка "Создание платежа"

DECLARE
    v_payment_details t_payment_details_array;
    v_payment_id      payment.payment_id%TYPE;
BEGIN
    v_payment_id := payment_api_pack.create_payment(v_payment_details, p_currency_id => 840, p_from_client_id => 1, p_to_client_id => 2
    , p_create_date => sysdate,
                                                   p_summa => 6000);

    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_input_parameter THEN
        dbms_output.put_line('Создание платежа. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка "Сброс статуса платежа"

DECLARE
    v_payment_id payment.payment_id%TYPE;
    v_reason     payment.status_change_reason%TYPE := 'Тестовый сброс платежа';
BEGIN
    payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_input_parameter THEN
        dbms_output.put_line('Сброс статуса платежа. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка "Отмена платежа"		

DECLARE
    v_payment_id payment.payment_id%TYPE := 29;
    v_reason     payment.status_change_reason%TYPE;
BEGIN
    payment_api_pack.cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_input_parameter THEN
        dbms_output.put_line('Отмена платежа. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка "Завершение платежа (успешно)"

DECLARE
    v_payment_id payment.payment_id%TYPE;
BEGIN
    payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_input_parameter THEN
        dbms_output.put_line('Завершение платежа. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка "Добавление/обновление данных платежа"

DECLARE
    v_payment_details t_payment_details_array;
    v_payment_id      payment.payment_id%TYPE := 29;
BEGIN
    payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id, p_payment_details => v_payment_details);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_input_parameter THEN
        dbms_output.put_line('Добавление/обновление данных платежа. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка "Удаление платежа"

DECLARE
    v_delete_field_pay t_numbers_array := t_numbers_array(1, 3);
    v_payment_id       payment.payment_id%TYPE;
BEGIN
    payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, p_delete_field_pay => v_delete_field_pay);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_input_parameter THEN
        dbms_output.put_line('Удаление данных платежа. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

--Проверки на испоьзование API

    --Проверка "Удаление платежа" через delete

DECLARE
    v_payment_id payment.payment_id%TYPE := -1;
BEGIN
    DELETE FROM payment p
    WHERE
        p.payment_id = v_payment_id;

    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_delete_forbidden THEN
        dbms_output.put_line('Удаление платежа. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка запрета вставки в Payment не через API

DECLARE
    v_payment_id payment.payment_id%TYPE := 1000;
BEGIN
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
        v_payment_id,
        sysdate,
        5000,
        840,
        2,
        1,
        payment_api_pack.c_status_create,
        NULL
    );

    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_manual_changes THEN
        dbms_output.put_line('Вставка в таблицу Payment не через API. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка "Сброс статуса платежа" обновление не через API

DECLARE
    v_payment_id payment.payment_id%TYPE := 29;
    v_reason     payment.status_change_reason%TYPE := 'Тестовый сброс платежа';
BEGIN
    UPDATE payment p1
    SET
        p1.status = payment_api_pack.c_status_error,
        p1.status_change_reason = v_reason
    WHERE
            p1.status = 0
        AND p1.payment_id = v_payment_id;

    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_manual_changes THEN
        dbms_output.put_line('Обновление таблицы Payment не через API. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/

    --Проверка на вставку данных платежа (Payment_detail) не через API

DECLARE
    v_payment_details t_payment_details_array;
    v_payment_id      payment.payment_id%TYPE := 29;
BEGIN
    INSERT INTO payment_detail (
        payment_id,
        field_id,
        field_value
    ) VALUES (
        v_payment_id,
        1,
        'char'
    );

    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_manual_changes THEN
        dbms_output.put_line('Добавление данных в таблицу Payment_detail не через API. Исключение возбуждено успершо. Ошибка: ' || sqlerrm
        );
END;
/

    --Проверка на обновление данных платежа (Payment_detail) не через API

DECLARE
    v_payment_id payment.payment_id%TYPE := 29;
BEGIN
    UPDATE payment_detail
    SET
        field_id = field_id
    WHERE
        payment_id = v_payment_id;

    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_manual_changes THEN
        dbms_output.put_line('Обновление данных в таблицу Payment_detail не через API. Исключение возбуждено успершо. Ошибка: ' || sqlerrm
        );
END;
/

    --Проверка на удаление данных платежа (Payment_detail) не через API

DECLARE
    v_payment_id payment.payment_id%TYPE := 29;
BEGIN
    DELETE FROM payment_detail
    WHERE
        payment_id = v_payment_id;

    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
EXCEPTION
    WHEN common_pack.invalid_manual_changes THEN
        dbms_output.put_line('Удаление данных в таблицу Payment_detail не через API. Исключение возбуждено успершо. Ошибка: ' || sqlerrm
        );
END;
/

    -- Негативный тест на отсутствие платежа
DECLARE
    v_payment_id payment.payment_id%TYPE := -666;
    v_reason     payment.status_change_reason%TYPE := 'Тестовая причина';
BEGIN
    payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
EXCEPTION
    WHEN common_pack.invalid_object_notfound THEN
        dbms_output.put_line('Платеж не найден. Исключение возбуждено успершо. Ошибка: ' || sqlerrm);
END;
/