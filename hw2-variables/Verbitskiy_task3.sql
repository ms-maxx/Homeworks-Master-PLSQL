set serveroutput on;

/*
�����: Verbitskiy M.S
�������� �������: API ��� ��������� ������� � ������� ��������
*/

--�������� �������
Declare 
  v_massage varchar2(50) :='������ ������';
  c_status constant number := 0;
Begin 
  dbms_output.put_line(v_massage || '. ������: ' || c_status);
end;
/
--����� �������
Declare 
  v_massage varchar2(100) := '����� ������� � "��������� ������" � ��������� �������';
  c_status constant number := 2;
  v_reason varchar2(50) :=  '������������ �������';
Begin 
  dbms_output.put_line(v_massage || '. ������: ' || c_status || '. �������: ' || v_reason);
end;
/
--������ �������
Declare 
  v_massage varchar2(100) := '������ ������� � ��������� �������';
  c_status constant number := 3;
  v_reason varchar2(50) :=  '������ ������������';
Begin 
  dbms_output.put_line(v_massage || '. ������: ' || c_status || '. �������: ' || v_reason);
end;
/
--���������� ������� (�������)
Declare 
  v_massage_end_payment varchar2(100) := '�������� ���������� �������';
  c_status constant number := 1;
Begin 
  dbms_output.put_line(v_massage_end_payment || '. ������: ' || c_status);
end;
/
--����������/���������� ������ �������
Declare 
v_massage_add_paymant varchar2(150) := '������ ������� ��������� ��� ��������� �� ������ id_����/��������';
Begin 
  dbms_output.put_line(v_massage_add_paymant);
end;
/
--�������� �������
Declare 
v_massage_drop_paymant varchar2(100) := '������ ������� ������� �� ������ id_�����';
Begin 
  dbms_output.put_line(v_massage_drop_paymant);
end;
/