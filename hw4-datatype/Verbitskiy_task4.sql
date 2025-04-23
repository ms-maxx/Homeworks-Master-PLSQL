set serveroutput on;

/*
�����: Verbitskiy M.S
�������� �������: API ��� ��������� ������� � ������� ��������
*/

--�������� �������
Declare 
  v_message varchar2(200 char) :='������ ������';
  c_status_create constant number(10) := 0;
  v_current_date date := sysdate; 
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_create);
  dbms_output.put_line(to_char(v_current_date, '"date: "dd.mon.YYYY "time: "hh24:mi:ss'));
end;
/
--����� �������
Declare 
  v_message varchar2(200 char) := '����� ������� � "��������� ������" � ��������� �������';
  c_status_error constant number(10) := 2;
  v_reason varchar2(200 char) :=  '������������ �������';
  v_current_date timestamp := systimestamp;
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_error || '. �������: ' || v_reason);
  dbms_output.put_line(to_char(v_current_date, 'DDsp MMsp YYYYsp hh24:ss:mi:ff5'));
end;
/
--������ �������
Declare 
  v_message varchar2(200 char) := '������ ������� � ��������� �������';
  c_status_cancel constant number(10) := 3;
  v_reason varchar2(200 char) :=  '������ ������������';
  v_current_date timestamp := systimestamp;
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_cancel || '. �������: ' || v_reason);
  dbms_output.put_line(to_char(v_current_date, 'dd.mm.YY hh24:ss:mi:ff5 "century: "CC'));
end;
/
--���������� ������� (�������)
Declare 
  v_message varchar2(200 char) := '�������� ���������� �������';
  c_status_end_pay_succes constant number(10) := 1;
  v_current_date date := sysdate; 
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_end_pay_succes);
  dbms_output.put_line(to_char(v_current_date, 'ddth "of" fmmonth "year:" fmYYYY "time: " fmhh24:mi:ss'));
end;
/
--����������/���������� ������ �������
Declare 
v_message varchar2(200 char) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������';
v_current_date date := sysdate; 
Begin 
  dbms_output.put_line(v_message);
  dbms_output.put_line(to_char(v_current_date, 'dd/mon/YYYY d.w.q'));
end;
/
--�������� �������
Declare 
v_message varchar2(200 char) := '������ ������� ������� �� ������ id_�����';
v_current_date timestamp := systimestamp;
Begin 
  dbms_output.put_line(v_message);
  dbms_output.put_line(to_char(v_current_date, 'dy MM YYYY hh12:ss:mi:ff5'));
end;
/