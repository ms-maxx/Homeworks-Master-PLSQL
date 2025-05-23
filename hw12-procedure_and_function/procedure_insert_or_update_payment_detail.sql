--ƒобавление/обновление данных платежа
Create or replace procedure insert_or_update_payment_detail(p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_payment_details t_payment_details_array)
is
v_message varchar2(200 char) := 'ƒанные платежа добавлены или обновлены по списку id_пол¤/значение';
v_current_date payment.CREATE_DTIME%type:= sysdate;
Begin 
     if p_payment_details is not empty then 
        for i in p_payment_details.first .. p_payment_details.last loop
            if (p_payment_details(i).field_id is null) then 
            dbms_output.put_line('ID пол¤ не может быть пустым');
            end if;
            
            if (p_payment_details(i).field_value is null) then 
            dbms_output.put_line('«начение в пол¤ не может быть пустым');
            end if;
            dbms_output.put_line('Failed_id: ' || p_payment_details(i).field_id || '. Value: ' || p_payment_details(i).field_value);
        end loop;
    else 
        dbms_output.put_line(' оллекци¤ не содержит данных');
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
/