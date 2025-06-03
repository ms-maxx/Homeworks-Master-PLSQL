Create or replace package body payment_detail_api_pack is

/*
�����: Verbitskiy M.S
�������� �������: API ��� ��������� ������� ��������
*/

--����������/���������� ������ �������

	procedure insert_or_update_payment_detail(p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_payment_details t_payment_details_array)
is
v_message varchar2(200 char) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������';
v_current_date date := sysdate; 
Begin 
     if p_payment_details is not empty then 
        for i in p_payment_details.first .. p_payment_details.last loop
            if (p_payment_details(i).field_id is null) then 
            raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_field_id);
            end if;
            
            if (p_payment_details(i).field_value is null) then 
            raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_field_value);
            end if;
            dbms_output.put_line('Failed_id: ' || p_payment_details(i).field_id || '. Value: ' || p_payment_details(i).field_value);
        end loop;
    else 
        raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_collection);
    end if;
	
	dbms_output.put_line(v_message || '. ID: ' || p_payment_id);
    dbms_output.put_line(to_char(v_current_date, 'dd/mon/YYYY d.w.q'));
    
  Merge into PAYMENT_DETAIL p1
  using (Select p_payment_id payment_id,
                value(t).field_id field_id,
                value(t).field_value field_value
        From table(p_payment_details) t) pd
        on (p1.payment_id = pd.payment_id and p1.field_id = pd.field_id)
        when matched then 
        Update set 
        p1.field_value = pd.field_value
        when not matched then 
        insert (payment_id, field_id, field_value)
        values (pd.payment_id, pd.field_id, pd.field_value);
end;


--�������� �������

	procedure delete_payment_detail (p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_delete_field_pay t_numbers_array)
is 
v_message varchar2(200 char) := '������ ������� ������� �� ������ id_�����';
v_current_date timestamp := systimestamp;
Begin  
    if p_payment_id is null 
    then raise_application_error(c_error_code_invalid_input_parameter, c_error_msg_empty_object_id);
    end if;
    
     if p_delete_field_pay is empty then 
        dbms_output.put_line(c_error_msg_empty_collection);
    end if;
    
    Delete from PAYMENT_DETAIL p1
    where p1.payment_id = p_payment_id
    and p1.field_id in (Select value(t) from table(p_delete_field_pay) t);
	
	dbms_output.put_line(v_message || '. ID: ' || p_payment_id);
    dbms_output.put_line(to_char(v_current_date, 'dy MM YYYY hh12:ss:mi:ff5'));
    dbms_output.put_line('���������� ��������� �����: ' || p_delete_field_pay.count());
end;


end;
/


