--����� �������
Create or replace procedure fail_payment(p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type) 
is 
  v_message varchar2(200 char) := '����� ������� � "��������� ������" � ��������� �������';
  c_status_error constant payment.status%type := 2;
  v_current_date payment.CREATE_DTIME%type := systimestamp;
  c_status_create constant payment.status%type := 0;
Begin 
    if p_payment_id is null 
    then dbms_output.put_line('ID ������� �� ����� ���� ������');
    end if;
    
    if p_reason is null 
    then dbms_output.put_line('������� �� ����� ���� ������');
    end if;
    
  dbms_output.put_line(v_message || '. ������: ' || c_status_error || '. �������: ' || p_reason || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'DDsp MMsp YYYYsp hh24:ss:mi:ff5'));
  
  -- ���������� ������� 
    Update Payment p1
    set p1.status = c_status_error,
        p1.status_change_reason = p_reason
    where p1.status = c_status_create 
    and p1.payment_id = p_payment_id;
end;
/