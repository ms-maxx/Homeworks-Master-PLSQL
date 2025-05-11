set serveroutput on;

/*
�����: Verbitskiy M.S
�������� �������: API ��� ��������� ������� � ������� ��������
*/

--�������� �������
Declare 
  v_message varchar2(200 char) :='������ ������';
  c_status_create constant payment.status%type := 0;
  v_current_date date := sysdate; 
  v_payment_id payment.payment_id%type;
  v_payment_details t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'CLIENT_SOFTWARE'),
                                                                    t_payment_detail(2, 'IP'),
                                                                    t_payment_detail(3, 'NOTE'),
                                                                    t_payment_detail(4, 'IS_CHECKED_FRAUD'));
Begin 
    if v_payment_details is not empty then 
        for i in v_payment_details.first .. v_payment_details.last loop
            if (v_payment_details(i).field_id is null) then 
            dbms_output.put_line('ID ���� �� ����� ���� ������');
            end if;
            
            if (v_payment_details(i).field_value is null) then 
            dbms_output.put_line('�������� � ���� �� ����� ���� ������');
            end if;
            dbms_output.put_line('Failed_id: ' || v_payment_details(i).field_id || '. Value: ' || v_payment_details(i).field_value);
        end loop;
    else 
        dbms_output.put_line('��������� �� �������� ������');
    end if;

  dbms_output.put_line(v_message || '. ������: ' || c_status_create || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, '"date: "dd.mon.YYYY "time: "hh24:mi:ss'));
end;
/
--����� �������
Declare 
  v_message varchar2(200 char) := '����� ������� � "��������� ������" � ��������� �������';
  c_status_error constant payment.status%type := 2;
  v_reason payment.status_change_reason%type :=  '������������ �������';
  v_current_date timestamp := systimestamp;
  v_payment_id payment.payment_id%type;
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID ������� �� ����� ���� ������');
    end if;
    
    if v_reason is null 
    then dbms_output.put_line('������� �� ����� ���� ������');
    end if;
    
  dbms_output.put_line(v_message || '. ������: ' || c_status_error || '. �������: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'DDsp MMsp YYYYsp hh24:ss:mi:ff5'));
end;
/
--������ �������
Declare 
  v_message varchar2(200 char) := '������ ������� � ��������� �������';
  c_status_cancel constant payment.status%type := 3;
  v_reason payment.status_change_reason%type :=  '������ ������������';
  v_current_date timestamp := systimestamp;
  v_payment_id payment.payment_id%type;
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID ������� �� ����� ���� ������');
    end if;
    
    if v_reason is null 
    then dbms_output.put_line('������� �� ����� ���� ������');
    end if;

  dbms_output.put_line(v_message || '. ������: ' || c_status_cancel || '. �������: ' || v_reason || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'dd.mm.YY hh24:ss:mi:ff5 "century: "CC'));
end;
/
--���������� ������� (�������)
Declare 
  v_message varchar2(200 char) := '�������� ���������� �������';
  c_status_end_pay_succes constant payment.status_change_reason%type := 1;
  v_current_date date := sysdate; 
  v_payment_id payment.payment_id%type;
Begin 
    if v_payment_id is null 
    then dbms_output.put_line('ID ������� �� ����� ���� ������');
    end if;
           
  dbms_output.put_line(v_message || '. ������: ' || c_status_end_pay_succes || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'ddth "of" fmmonth "year:" fmYYYY "time: " fmhh24:mi:ss'));
end;
/
--����������/���������� ������ �������
Declare 
v_message varchar2(200 char) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������';
v_current_date date := sysdate; 
v_payment_id payment.payment_id%type;
v_payment_details t_payment_details_array := t_payment_details_array(t_payment_detail(1, 'CLIENT_SOFTWARE'),
                                                                    t_payment_detail(2, 'IP'),
                                                                    t_payment_detail(3, 'NOTE'),
                                                                    t_payment_detail(4, 'IS_CHECKED_FRAUD'));
Begin 
     if v_payment_details is not empty then 
        for i in v_payment_details.first .. v_payment_details.last loop
            if (v_payment_details(i).field_id is null) then 
            dbms_output.put_line('ID ���� �� ����� ���� ������');
            end if;
            
            if (v_payment_details(i).field_value is null) then 
            dbms_output.put_line('�������� � ���� �� ����� ���� ������');
            end if;
            dbms_output.put_line('Failed_id: ' || v_payment_details(i).field_id || '. Value: ' || v_payment_details(i).field_value);
        end loop;
    else 
        dbms_output.put_line('��������� �� �������� ������');
    end if;
    
  dbms_output.put_line(v_message || '. ID: ' || v_payment_id);
  dbms_output.put_line(to_char(v_current_date, 'dd/mon/YYYY d.w.q'));
end;
/
--�������� �������
Declare 
v_message varchar2(200 char) := '������ ������� ������� �� ������ id_�����';
v_current_date timestamp := systimestamp;
v_payment_id payment.payment_id%type;
v_delete_field_pay t_numbers_array :=t_numbers_array(1,2,3);
Begin  
    if v_payment_id is null 
    then dbms_output.put_line('ID ������� �� ����� ���� ������');
    end if;
    
     if v_delete_field_pay is empty then 
        dbms_output.put_line('��������� �� �������� ������');
    end if;
    
    dbms_output.put_line(v_message || '. ID: ' || v_payment_id);
    dbms_output.put_line(to_char(v_current_date, 'dy MM YYYY hh12:ss:mi:ff5'));
    dbms_output.put_line('���������� ��������� �����: ' || v_delete_field_pay.count());
end;
/

