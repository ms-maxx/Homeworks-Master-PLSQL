set serveroutput on;

/*
�����: Verbitskiy M.S
�������� �������: API ��� ��������� ������� � ������� ��������
*/

--�������� �������
Declare 
  v_message varchar2(50) :='������ ������';
  c_status_create constant number := 0;
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_create);
end;
/
--����� �������
Declare 
  v_message varchar2(100 char) := '����� ������� � "��������� ������" � ��������� �������';
  c_status_error constant number := 2;
  v_reason varchar2(50) :=  '������������ �������';
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_error || '. �������: ' || v_reason);
end;
/
--������ �������
Declare 
  v_message varchar2(100) := '������ ������� � ��������� �������';
  c_status_cancel constant number := 3;
  v_reason varchar2(50) :=  '������ ������������';
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_cancel || '. �������: ' || v_reason);
end;
/
--���������� ������� (�������)
Declare 
  v_message varchar2(100) := '�������� ���������� �������';
  c_status_end_pay_succes constant number := 1;
Begin 
  dbms_output.put_line(v_message || '. ������: ' || c_status_end_pay_succes);
end;
/
--����������/���������� ������ �������
Declare 
v_message varchar2(150) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������';
Begin 
  dbms_output.put_line(v_message);
end;
/
--�������� �������
Declare 
v_message varchar2(100) := '������ ������� ������� �� ������ id_�����';
Begin 
  dbms_output.put_line(v_message);
end;
/