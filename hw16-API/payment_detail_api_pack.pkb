create or replace package body payment_detail_api_pack is

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Детали платежа”
*/
    g_is_api boolean := false; -- Признак выполенения через API
    
    --Разрешение изменять данные
    procedure allow_changes is
    Begin 
        g_is_api := true;
    end;
    
    --Запрет на изменения данных
    procedure disallow_changes is
    Begin 
        g_is_api := false;
    end;
    
--Добавление/обновление данных платежа

	procedure insert_or_update_payment_detail(p_payment_id PAYMENT_DETAIL.payment_id%type, 
p_payment_details t_payment_details_array)
is
Begin 
     if p_payment_details is not empty then 
        for i in p_payment_details.first .. p_payment_details.last loop
            if (p_payment_details(i).field_id is null) then 
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_field_id);
            end if;

            if (p_payment_details(i).field_value is null) then 
            raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_field_value);
            end if;
        end loop;
    else 
        raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_collection);
    end if;

    allow_changes();
    
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
        
    disallow_changes();
    
    Exception when others then 
        disallow_changes();
        raise;
    end;


--Удаление платежа

	procedure delete_payment_detail (p_payment_id PAYMENT_DETAIL.payment_id%type, 
    p_delete_field_pay t_numbers_array)
    is 
    Begin  
        if p_payment_id is null 
        then raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
        end if;

         if p_delete_field_pay is null or p_delete_field_pay is empty 
         then raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_collection);
        end if;

    allow_changes();
    
        Delete from PAYMENT_DETAIL p1
            where p1.payment_id = p_payment_id
        and p1.field_id in (Select value(t) from table(p_delete_field_pay) t);
    
    disallow_changes();

    Exception when others then 
        disallow_changes();
        raise;
    end;
    
    procedure is_changes_through_api 
    is 
    Begin 
        if not g_is_api and not common_pack.is_manual_changes_allowed() then 
            raise_application_error(common_pack.c_error_code_manual_changes, common_pack.c_error_msg_manual_changes);
        end if;
    end;
    
end payment_detail_api_pack;