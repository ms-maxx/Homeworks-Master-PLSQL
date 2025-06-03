--�������� "�������� �������"

Declare 
v_payment_details t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'CLIENT_SOFTWARE'),
                                                                    t_payment_detail(2, 'IP'),
                                                                    t_payment_detail(3, 'NOTE'),
                                                                    t_payment_detail(4, 'IS_CHECKED_FRAUD'));

v_payment_id payment.payment_id%type;																
Begin
	v_payment_id := payment_api_pack.create_payment(v_payment_details, 
								   p_currency_id => 840,
								   p_from_client_id => 1,
								   p_to_client_id =>2,
                                   p_create_date => sysdate,
                                   p_summa => 6000);
	dbms_output.put_line('Payment ID:' || v_payment_id);
end;
/
commit;
--�������� "����� ������� �������"

Declare 
v_payment_id payment.payment_id%type := 29;
v_reason payment.status_change_reason%type := '�������� ����� �������';
Begin 
	payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
End;
/

--�������� "������ �������"		

Declare 
v_payment_id payment.payment_id%type := 29;
v_reason payment.status_change_reason%type := '�������� ������ �������';
Begin 
	payment_api_pack.cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
End;
/

--�������� "���������� ������� (�������)"

Declare 
v_payment_id payment.payment_id%type := 29;
Begin 
	payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
End;
/

--�������� "����������/���������� ������ �������"

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

--�������� "�������� �������"

Declare 
	v_delete_field_pay t_numbers_array :=t_numbers_array(1,3);
	v_payment_id payment.payment_id%type :=29;
Begin 
	payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, 
						  p_delete_field_pay =>v_delete_field_pay);
End;
/

-- ���������� Unit-�����
-- �������� "�������� �������"

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
	raise_application_error(-20999, 'Unit-����, ��� API ��������� �������');
Exception 
    when payment_api_pack.invalid_input_parameter then 
    dbms_output.put_line('�������� �������. ���������� ���������� �������. ������: '|| sqlerrm);
end;
/

--�������� "����� ������� �������"

Declare 
v_payment_id payment.payment_id%type;
v_reason payment.status_change_reason%type := '�������� ����� �������';
Begin 
	payment_api_pack.fail_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    raise_application_error(-20999, 'Unit-����, ��� API ��������� �������');
Exception 
    when payment_api_pack.invalid_input_parameter then 
    dbms_output.put_line('����� ������� �������. ���������� ���������� �������. ������: '|| sqlerrm);
End;
/

--�������� "������ �������"		

Declare 
v_payment_id payment.payment_id%type := 29;
v_reason payment.status_change_reason%type;
Begin 
	payment_api_pack.cancel_payment(p_payment_id => v_payment_id, p_reason => v_reason);
    raise_application_error(-20999, 'Unit-����, ��� API ��������� �������');
Exception 
    when payment_api_pack.invalid_input_parameter then 
    dbms_output.put_line('������ �������. ���������� ���������� �������. ������: '|| sqlerrm);
End;
/

--�������� "���������� ������� (�������)"

Declare 
v_payment_id payment.payment_id%type;
Begin 
	payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
    raise_application_error(-20999, 'Unit-����, ��� API ��������� �������');
Exception 
    when payment_api_pack.invalid_input_parameter then 
    dbms_output.put_line('���������� �������. ���������� ���������� �������. ������: '|| sqlerrm);
End;
/

--�������� "����������/���������� ������ �������"

Declare 
	v_payment_details t_payment_details_array;
	v_payment_id payment.payment_id%type := 29;																	
Begin 
	payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id,
									p_payment_details => v_payment_details);
    raise_application_error(-20999, 'Unit-����, ��� API ��������� �������');
Exception 
    when payment_detail_api_pack.invalid_input_parameter then 
    dbms_output.put_line('����������/���������� ������ �������. ���������� ���������� �������. ������: '|| sqlerrm);
End;
/

--�������� "�������� �������"

Declare 
	v_delete_field_pay t_numbers_array :=t_numbers_array(1,3);
	v_payment_id payment.payment_id%type;
Begin 
	payment_detail_api_pack.delete_payment_detail(p_payment_id => v_payment_id, 
						  p_delete_field_pay =>v_delete_field_pay);
    raise_application_error(-20999, 'Unit-����, ��� API ��������� �������');
Exception 
    when payment_detail_api_pack.invalid_input_parameter then 
    dbms_output.put_line('�������� �������. ���������� ���������� �������. ������: '|| sqlerrm);
End;
/






