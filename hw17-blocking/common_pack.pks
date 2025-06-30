CREATE OR REPLACE PACKAGE common_pack IS 

--Сообщения об ошибках

    c_error_msg_empty_field_id CONSTANT VARCHAR2(100 CHAR) := 'ID поля не может быть пустым';
    c_error_msg_empty_field_value CONSTANT VARCHAR2(100 CHAR) := 'Значение в поле не может быть пустым';
    c_error_msg_empty_collection CONSTANT VARCHAR2(100 CHAR) := 'Коллекция не содержит данных';
    c_error_msg_empty_object_id CONSTANT VARCHAR2(100 CHAR) := 'ID объекта не может быть пустым';
    c_error_msg_empty_reason CONSTANT VARCHAR2(100 CHAR) := 'Причина не может быть пустой';
    c_error_msg_delete_forbidden CONSTANT VARCHAR2(100 CHAR) := 'Удаление объекта запрещено';
    c_error_msg_manual_changes CONSTANT VARCHAR2(100 CHAR) := 'Изменения должны выполняться только через API';
    c_error_msg_infinal_object CONSTANT VARCHAR2(100 CHAR) := 'Объект в конечном статусе. Изменения невозможны';
    c_error_msg_object_notfound CONSTANT VARCHAR2(100 CHAR) := 'Объект не найден';
    c_error_msg_object_already_locked CONSTANT VARCHAR2(100 CHAR) := 'Объект уже заблокирован';

--Коды ошибок

    c_error_code_invalid_input_parameter CONSTANT NUMBER(10) := -20101;
    c_error_code_delete_forbidden CONSTANT NUMBER(10) := -20102;
    c_error_code_manual_changes CONSTANT NUMBER(10) := -20103;
    c_error_code_infinal_object CONSTANT NUMBER(10) := -20104;
    c_error_code_object_notfound CONSTANT NUMBER(10) := -20105;
    c_error_code_object_already_locked CONSTANT NUMBER(10) := -20106;

--Объекты исключений

    invalid_input_parameter EXCEPTION;
    PRAGMA exception_init ( invalid_input_parameter, c_error_code_invalid_input_parameter );
    invalid_delete_forbidden EXCEPTION;
    PRAGMA exception_init ( invalid_delete_forbidden, c_error_code_delete_forbidden );
    invalid_manual_changes EXCEPTION;
    PRAGMA exception_init ( invalid_manual_changes, c_error_code_manual_changes );
    invalid_infinal_object EXCEPTION;
    PRAGMA exception_init ( invalid_infinal_object, c_error_code_infinal_object );
    invalid_object_notfound EXCEPTION;
    PRAGMA exception_init ( invalid_object_notfound, c_error_code_object_notfound );
    invalid_row_locked EXCEPTION;
    PRAGMA exception_init ( invalid_row_locked, -00054 );
    
--Включение/Отключение разрешения менять в ручную данные объектов

    PROCEDURE enable_manual_changes;

    PROCEDURE disable_manual_changes;
    --Разрешены ли ручные изменения на глобальном уровне
    FUNCTION is_manual_changes_allowed RETURN BOOLEAN;

END common_pack;