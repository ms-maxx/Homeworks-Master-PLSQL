--������ �������
Create or replace procedure cancel_payment(p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type)
is
  v_message varchar2(200 char) := '������ ������� � ��������� �������';
  c_status_cancel constant payment.status%type := 3;
  v_current_date payment.CREATE_DTIME%type := systimestamp;
  c_status_create constant payment.status%type := 0;
Begin 
    if p_payment_id is null 
    then dbms_output.put_line('ID ������� �� ����� ���� ������');
    end if;
    
    if p_reason is null 
    then dbms_output.put_line('������� �� ����� ���� ������');
    end if;

  dbms_output.put_line(v_message || '. ������: ' || c_status_cancel || '. �������: ' || p_reason || '. ID: ' || p_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'dd.mm.YY hh24:ss:mi:ff5 "century: "CC'));
  
  -- ���������� ������� 
    Update Payment p1
    set p1.status = c_status_cancel,
        p1.status_change_reason = p_reason
    where p1.status = c_status_create
    and p1.payment_id = p_payment_id;
end;
/