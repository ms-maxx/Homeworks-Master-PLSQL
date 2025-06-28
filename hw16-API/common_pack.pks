create or replace package common_pack is 

--Сообщения об ошибках

	c_error_msg_empty_field_id constant varchar2(100 char) := 'ID поля не может быть пустым';
	c_error_msg_empty_field_value constant varchar2(100 char) := 'Значение в поле не может быть пустым';
	c_error_msg_empty_collection constant varchar2(100 char) := 'Коллекция не содержит данных';
	c_error_msg_empty_object_id constant varchar2(100 char) := 'ID объекта не может быть пустым';
	c_error_msg_empty_reason constant varchar2(100 char) := 'Причина не может быть пустой';
    c_error_msg_delete_forbidden constant varchar2(100 char) := 'Удаление объекта запрещено';
    c_error_msg_manual_changes constant varchar2(100 char) := 'Изменения должны выполняться только через API';

--Коды ошибок

    c_error_code_invalid_input_parameter constant number(10) := -20101;
    c_error_code_delete_forbidden constant number(10) := -20102;
    c_error_code_manual_changes constant number(10) := -20103;

--Объекты исключений

    invalid_input_parameter exception;
    pragma exception_init(invalid_input_parameter, c_error_code_invalid_input_parameter);
    invalid_delete_forbidden exception;
    pragma exception_init(invalid_delete_forbidden, c_error_code_delete_forbidden);
    invalid_manual_changes exception;
    pragma exception_init(invalid_manual_changes, c_error_code_manual_changes);
    
--Включение/Отключение разрешения менять в ручную данные объектов
    
    procedure enable_manual_changes;
    procedure disable_manual_changes;
    --Разрешены ли ручные изменения на глобальном уровне
    function is_manual_changes_allowed return boolean;

end common_pack;
