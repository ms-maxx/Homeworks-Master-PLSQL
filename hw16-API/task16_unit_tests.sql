--Проверка "Создания платежа"

Declare 
v_payment_details t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'CLIENT_SOFTWARE'),
                                                                    t_payment_detail(2, 'IP'),
                                                                    t_payment_detail(3, 'NOTE'),
                                                                    t_payment_detail(4, 'IS_CHECKED_FRAUD'));

v_payment_id payment.payment_id%type;
v_create_dtime_tech payment.create_dtime_tech%type;
v_update_dtime_tech payment.update_dtime_tech% type;
Begin
	v_payment_id := payment_api_pack.create_payment(v_payment_details, 
								   p_currency_id => 840,
								   p_from_client_id => 1,
								   p_to_client_id =>2,
                                   p_create_date => sysdate,
                                   p_summa => 6000);
	dbms_output.put_line('Payment ID:' || v_payment_id);
    
    Select p.create_dtime_tech, p.update_dtime_tech 
        into v_create_dtime_tech, v_update_dtime_tech
        from payment p
    where p.payment_id = v_payment_id;
    
    if v_create_dtime_tech != v_update_dtime_tech then 
        raise_application_error(-20998, 'Технические даты разные!');
    end if;
    
end;
/

--Проверка "Сброс статуса платежа"

Declare 
v_payment_id payment.payment_id%type := 109;
v_reason payment.status_change_reason%type := 'Тестовый сброс платежа';
v_create_dtime_tech payment.create_dtime_tech%type;
v_update_dtime_tech payment.update_dtime_tech% type;
Begin 
	payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    
    Select p.create_dtime_tech, p.update_dtime_tech 
        into v_create_dtime_tech, v_update_dtime_tech
        from payment p
    where p.payment_id = v_payment_id;
    
    if v_create_dtime_tech = v_update_dtime_tech then 
        raise_application_error(-20998, 'Технические даты равны!');
    end if;
End;
/

--Проверка "Отмена платежа"		

Declare 
v_payment_id payment.payment_id%type := 109;
v_reason payment.status_change_reason%type := 'Тестовая отмена платежа';
v_create_dtime_tech payment.create_dtime_tech%type;
v_update_dtime_tech payment.update_dtime_tech% type;
Begin 
	payment_api_pack.cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    
     Select p.create_dtime_tech, p.update_dtime_tech 
        into v_create_dtime_tech, v_update_dtime_tech
        from payment p
    where p.payment_id = v_payment_id;
    
    if v_create_dtime_tech = v_update_dtime_tech then 
        raise_application_error(-20998, 'Технические даты равны!');
    end if;
End;
/

--Проверка "Завершение платежа (успешно)"

Declare 
v_payment_id payment.payment_id%type := 109;
v_create_dtime_tech payment.create_dtime_tech%type;
v_update_dtime_tech payment.update_dtime_tech% type;
Begin 
	payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
    
    Select p.create_dtime_tech, p.update_dtime_tech 
        into v_create_dtime_tech, v_update_dtime_tech
        from payment p
    where p.payment_id = v_payment_id;
    
    if v_create_dtime_tech = v_update_dtime_tech then 
        raise_application_error(-20998, 'Технические даты равны!');
    end if;
End;
/

--Проверка "Добавление/обновление данных платежа"

Declare 
	v_payment_details t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'windows'),
                                                                    t_payment_detail(2, '172.19.45.79'),
                                                                    t_payment_detail(3, 'mail_3@com'),
                                                                    t_payment_detail(4, 'mail_4@com'));
	v_payment_id payment.payment_id%type := 29;																	
Begin 
	payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id,
									p_payment_details => v_payment_details);
End;
/

--Проверка "Удаление платежа"

Declare 
	v_delete_field_pay t_numbers_array :=t_numbers_array(1,3);
	v_payment_id payment.payment_id%type :=110;
Begin 
	payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, 
						  p_delete_field_pay =>v_delete_field_pay);
End;
/

--Проверка функционала по глобальному отключению проверок. 

    --Операция уаление платежа
    
Declare 
	v_payment_id payment.payment_id%type := -1;
Begin 
    common_pack.enable_manual_changes();
    
	Delete from payment p where p.payment_id = v_payment_id;
    
    common_pack.disable_manual_changes();
Exception 
    when others then 
    common_pack.disable_manual_changes();
    raise;
End;
/

    --Операция обновления платежа

Declare 
	v_payment_id payment.payment_id%type := -1;
Begin 
    common_pack.enable_manual_changes();
    
	Update Payment p1
    set p1.status = payment_api_pack.c_status_error
    where p1.status = 0 
    and p1.payment_id = v_payment_id;
    
    common_pack.disable_manual_changes();
Exception 
    when others then 
    common_pack.disable_manual_changes();
    raise;
End;
/ 

    --Операция обновления деталей платежа

Declare 
	v_payment_id payment.payment_id%type := -1;
Begin 
    common_pack.enable_manual_changes();
    
	Update payment_detail 
    set FIELD_ID = FIELD_ID
    where payment_id  = v_payment_id;
    
    common_pack.disable_manual_changes();
Exception 
    when others then 
    common_pack.disable_manual_changes();
    raise;
End;
/  

-- Негативные Unit-тесты

    -- Проверка "Создание платежа"

Declare 
v_payment_details t_payment_details_array;

v_payment_id payment.payment_id%type;																
Begin
	v_payment_id := payment_api_pack.create_payment(v_payment_details, 
								   p_currency_id => 840,
								   p_from_client_id => 1,
								   p_to_client_id =>2,
                                   p_create_date => sysdate,
                                   p_summa => 6000);
	raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_input_parameter then 
    dbms_output.put_line('Создание платежа. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
end;
/

    --Проверка "Сброс статуса платежа"

Declare 
v_payment_id payment.payment_id%type;
v_reason payment.status_change_reason%type := 'Тестовый сброс платежа';
Begin 
	payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_input_parameter then 
    dbms_output.put_line('Сброс статуса платежа. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка "Отмена платежа"		

Declare 
v_payment_id payment.payment_id%type := 29;
v_reason payment.status_change_reason%type;
Begin 
	payment_api_pack.cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_input_parameter then 
    dbms_output.put_line('Отмена платежа. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка "Завершение платежа (успешно)"

Declare 
v_payment_id payment.payment_id%type;
Begin 
	payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_input_parameter then 
    dbms_output.put_line('Завершение платежа. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка "Добавление/обновление данных платежа"

Declare 
	v_payment_details t_payment_details_array;
	v_payment_id payment.payment_id%type := 29;																	
Begin 
	payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id,
									p_payment_details => v_payment_details);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_input_parameter then 
    dbms_output.put_line('Добавление/обновление данных платежа. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка "Удаление платежа"

Declare 
	v_delete_field_pay t_numbers_array :=t_numbers_array(1,3);
	v_payment_id payment.payment_id%type;
Begin 
	payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, 
						  p_delete_field_pay =>v_delete_field_pay);
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_input_parameter then 
    dbms_output.put_line('Удаление данных платежа. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

--Проверки на испоьзование API

    --Проверка "Удаление платежа" через delete

Declare 
	v_payment_id payment.payment_id%type := -1;
Begin 
	Delete from payment p where p.payment_id = v_payment_id;
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_delete_forbidden then 
    dbms_output.put_line('Удаление платежа. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка запрета вставки в Payment не через API

Declare 
	v_payment_id payment.payment_id%type := 1000;
Begin 
	Insert into Payment (PAYMENT_ID,
                        CREATE_DTIME,
                        SUMMA,
                        CURRENCY_ID,
                        FROM_CLIENT_ID,
                        TO_CLIENT_ID,
                        STATUS,
                        STATUS_CHANGE_REASON)
    values (v_payment_id, sysdate, 5000, 840, 
            2, 1, payment_api_pack.c_status_create, null);
    
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_manual_changes then 
    dbms_output.put_line('Вставка в таблицу Payment не через API. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка "Сброс статуса платежа" обновление не через API

Declare 
v_payment_id payment.payment_id%type := 29;
v_reason payment.status_change_reason%type := 'Тестовый сброс платежа';
Begin 
	Update Payment p1
    set p1.status = payment_api_pack.c_status_error,
        p1.status_change_reason = v_reason
    where p1.status = 0 
    and p1.payment_id = v_payment_id;
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_manual_changes then 
    dbms_output.put_line('Обновление таблицы Payment не через API. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка на вставку данных платежа (Payment_detail) не через API

Declare 
	v_payment_details t_payment_details_array;
	v_payment_id payment.payment_id%type := 29;																	
Begin 
	insert into payment_detail (PAYMENT_ID, FIELD_ID, FIELD_VALUE) 
    values (v_payment_id, 1, 'char');
    
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_manual_changes then 
    dbms_output.put_line('Добавление данных в таблицу Payment_detail не через API. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка на обновление данных платежа (Payment_detail) не через API

Declare 
	v_payment_id payment.payment_id%type := 29;																	
Begin 
	Update payment_detail 
    set FIELD_ID = FIELD_ID
    where payment_id  = v_payment_id;
    
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_manual_changes then 
    dbms_output.put_line('Обновление данных в таблицу Payment_detail не через API. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/

    --Проверка на удаление данных платежа (Payment_detail) не через API

Declare 
	v_payment_id payment.payment_id%type := 29;																	
Begin 
	Delete from payment_detail 
    where payment_id = v_payment_id;
    raise_application_error(-20999, 'Unit-тест, или API выполнены неверно');
Exception 
    when common_pack.invalid_manual_changes then 
    dbms_output.put_line('Удаление данных в таблицу Payment_detail не через API. Исключение возбуждено успершо. Ошибка: '|| sqlerrm);
End;
/





