--Проверка "Создания платежа"

Declare 
v_payment_details t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'CLIENT_SOFTWARE'),
                                                                    t_payment_detail(2, 'IP'),
                                                                    t_payment_detail(3, 'NOTE'),
                                                                    t_payment_detail(4, 'IS_CHECKED_FRAUD'));

v_payment_id payment.payment_id%type;																
Begin
	v_payment_id := create_payment(v_payment_details, 
								   p_currency_id => 840,
								   p_from_client_id => 1,
								   p_to_client_id =>2);
	dbms_output.put_line('Payment ID:' || v_payment_id);
end;
/
commit;
--Проверка "Сброс статуса платежа"

Declare 
v_payment_id payment.payment_id%type := 29;
v_reason payment.status_change_reason%type := 'Тестовый сброс платежа';
Begin 
	fail_payment (p_payment_id => v_payment_id, p_reason => v_reason);
End;
/

--Проверка "Отмена платежа"		

Declare 
v_payment_id payment.payment_id%type := 29;
v_reason payment.status_change_reason%type := 'Тестовая отмена платежа';
Begin 
	cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
End;
/

--Проверка "Завершение платежа (успешно)"

Declare 
v_payment_id payment.payment_id%type := 29;
Begin 
	successful_finish_payment(p_payment_id => v_payment_id);
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
	insert_or_update_payment_detail(p_payment_id => v_payment_id,
									p_payment_details => v_payment_details);
End;
/

--Проверка "Удаление платежа"

Declare 
	v_delete_field_pay t_numbers_array :=t_numbers_array(1,3);
	v_payment_id payment.payment_id%type :=29;
Begin 
	delete_payment_detail(p_payment_id => v_payment_id, 
						  p_delete_field_pay =>v_delete_field_pay);
End;
/


									