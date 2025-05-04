set serveroutput on;

declare 
    type t_my_rec is record (
                v_var1 number,
                v_var2 varchar2(50 char) not null := 'Hello!',
                v_var3 date := sysdate
                );
    
    v_rec1 t_my_rec;
    v_rec2 t_my_rec;
    v_rec3 t_my_rec;
Begin 
    --Присваиваем значения
    v_rec1.v_var1 := 10;
    v_rec2.v_var1 := 20;
    v_rec3.v_var1 := 30;
    
    dbms_output.put_line('v_rec1: '|| v_rec1.v_var1);
    dbms_output.put_line('v_rec2: '|| v_rec2.v_var1);
    dbms_output.put_line('v_rec3: '|| v_rec3.v_var1);
    
    --Выполняем условие проверки 
    --Вариант 1
    /*v_rec3.v_var3 := null;
    
    if v_rec3.v_var3 is null then 
    dbms_output.put_line('It’s null');
    else 
    dbms_output.put_line('It’s not null');
    end if;*/
    --Вариант 2 
    v_rec3 := null;
    
    case 
    when (v_rec3.v_var1 is null and v_rec3.v_var2 is null and v_rec3.v_var3 is null) 
    then dbms_output.put_line('It’s null');
    else 
    dbms_output.put_line('It’s not null');
    end case;
end;
/
                