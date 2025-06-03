Create or replace package payment_detail_api_pack is

/*
�����: Verbitskiy M.S
�������� �������: API ��� ��������� ������� ��������
*/

--��������� �� �������
	c_error_msg_empty_field_id constant varchar2(100 char) := 'ID ���� �� ����� ���� ������';
	c_error_msg_empty_field_value constant varchar2(100 char) := '�������� � ���� �� ����� ���� ������';
	c_error_msg_empty_collection constant varchar2(100 char) := '��������� �� �������� ������';
	c_error_msg_empty_object_id constant varchar2(100 char) := 'ID ������� �� ����� ���� ������';
    
--���� �������
    
    c_error_code_invalid_input_parameter constant number(10) := -20101;

--������� ����������
    invalid_input_parameter exception;
    pragma exception_init(invalid_input_parameter, c_error_code_invalid_input_parameter);
	

--����������/���������� ������ �������

	procedure insert_or_update_payment_detail(p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_payment_details t_payment_details_array);

--�������� �������

	procedure delete_payment_detail (p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_delete_field_pay t_numbers_array);

end;
/


