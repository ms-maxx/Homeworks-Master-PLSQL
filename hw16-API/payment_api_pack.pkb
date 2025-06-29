create or replace package body payment_api_pack is

/*
Автор: Verbitskiy M.S
Описание скрипта: API для сущностей “Платеж” 
*/

--Создание платежа

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
        

	function create_payment(p_payment_details t_payment_details_array,
p_currency_id payment.currency_id%type,
p_from_client_id payment.from_client_id%type,
p_to_client_id payment.to_client_id%type,
p_create_date payment.CREATE_DTIME%type,
p_summa payment.summa%type) return payment.payment_id%type
is
  v_payment_id payment.payment_id%type;

Begin   
  -- Создание платжа
    allow_changes();
    
    Insert into Payment (PAYMENT_ID,
                        CREATE_DTIME,
                        SUMMA,
                        CURRENCY_ID,
                        FROM_CLIENT_ID,
                        TO_CLIENT_ID,
                        STATUS,
                        STATUS_CHANGE_REASON)
    values (PAYMENT_SEQ.nextval, p_create_date, p_summa, p_currency_id, 
            p_from_client_id, p_to_client_id, c_status_create, null)
    returning PAYMENT_ID into v_payment_id;
    
   -- Добавление данных платежа
   payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id => v_payment_id,
   p_payment_details => p_payment_details);   
   
   disallow_changes();
   
   return v_payment_id;
   
Exception when others then 
    disallow_changes();
    raise;
end;


--Сброс платежа

	procedure fail_payment (p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type) 
is 
Begin 
    if p_payment_id is null 
    then raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
    end if;

    if p_reason is null 
    then raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_reason);
    end if;

  -- Обновление платежа 
    
     allow_changes();

    Update Payment p1
    set p1.status = c_status_error,
        p1.status_change_reason = p_reason
    where p1.status = c_status_create 
    and p1.payment_id = p_payment_id;
    
    disallow_changes();

Exception when others then 
    disallow_changes();
    raise;
end;


--Отмена платежа

	procedure cancel_payment(p_payment_id payment.payment_id%type, 
p_reason payment.status_change_reason%type)
is
Begin 
    if p_payment_id is null 
    then raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
    end if;

    if p_reason is null 
    then raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_reason);
    end if;

  -- Обновление платежа 
    
    allow_changes();
    
    Update Payment p1
    set p1.status = c_status_cancel,
        p1.status_change_reason = p_reason
    where p1.status = c_status_create
    and p1.payment_id = p_payment_id;
    
    disallow_changes();
    
Exception when others then 
    disallow_changes();
    raise;
end;


--Завершение платежа (успешно)

	procedure successful_finish_payment(p_payment_id payment.payment_id%type)
is 
Begin 
    if p_payment_id is null 
    then raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_error_msg_empty_object_id);
    end if;

  -- Обновление платежа 
    
    allow_changes();

    Update Payment p1
    set p1.status = c_status_end_pay_succes,
        p1.status_change_reason = null
    where p1.status = c_status_create
    and p1.payment_id = p_payment_id;
    
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
    
    procedure check_client_delete_restriction
    is 
    Begin
        if not common_pack.is_manual_changes_allowed() then 
            raise_application_error(common_pack.c_error_code_delete_forbidden, common_pack.c_error_msg_delete_forbidden);
        end if;
    end;

end payment_api_pack;