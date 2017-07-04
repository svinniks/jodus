CREATE OR REPLACE PACKAGE json_store IS

    TYPE t_path_element IS RECORD
        (type CHAR
        ,value VARCHAR2(4000));
        
    TYPE t_path_elements IS TABLE OF t_path_element;
    
    TYPE t_property IS RECORD
        (parent_id NUMBER
        ,parent_type CHAR
        ,property_id NUMBER
        ,property_type CHAR
        ,property_name VARCHAR2(4000));
        
    TYPE t_properties IS TABLE OF t_property;
    
    TYPE t_value IS RECORD
        (id NUMBER
        ,type CHAR
        ,value VARCHAR2(4000));
        
    TYPE t_values IS TABLE OF t_value;

    FUNCTION parse_path
        (p_path IN VARCHAR2)
    RETURN t_path_elements;
    
    PROCEDURE request_properties
        (p_path IN VARCHAR2
        ,p_properties OUT SYS_REFCURSOR);
        
    FUNCTION request_properties
        (p_path IN VARCHAR2)
    RETURN t_properties PIPELINED;
    
    FUNCTION create_json
        (-- @json
         p_content IN VARCHAR2)
    RETURN NUMBER;
    
    FUNCTION create_json_clob
        (-- @json
         p_content IN CLOB)
    RETURN NUMBER;
    
    FUNCTION create_string
        (p_value IN VARCHAR2)
    RETURN NUMBER;
    
    FUNCTION create_number
        (p_value IN NUMBER)
    RETURN NUMBER;
    
    FUNCTION create_boolean
        (p_value IN BOOLEAN)
    RETURN NUMBER;
    
    FUNCTION create_null
    RETURN NUMBER;

    FUNCTION create_object
    RETURN NUMBER;
    
    FUNCTION create_array
    RETURN NUMBER;
    
    FUNCTION set_json
        (p_path IN VARCHAR2
        ,-- @json
         p_content IN VARCHAR2)
    RETURN NUMBER;
    
    FUNCTION set_json_clob
        (p_path IN VARCHAR2
        ,-- @json
         p_content IN CLOB)
    RETURN NUMBER;
    
    FUNCTION set_string
        (p_path IN VARCHAR2
        ,p_value IN VARCHAR2)
    RETURN NUMBER;
    
    FUNCTION set_number
        (p_path IN VARCHAR2
        ,p_value IN NUMBER)
    RETURN NUMBER;
    
    FUNCTION set_boolean
        (p_path IN VARCHAR2
        ,p_value IN BOOLEAN)
    RETURN NUMBER;
    
    FUNCTION set_null
        (p_path IN VARCHAR2)
    RETURN NUMBER;
    
    FUNCTION set_object
        (p_path IN VARCHAR2)
    RETURN NUMBER;
    
    FUNCTION set_array
        (p_path IN VARCHAR2)
    RETURN NUMBER;

    PROCEDURE request_values
        (p_path IN VARCHAR2
        ,p_values OUT SYS_REFCURSOR);
        
    FUNCTION request_values
        (p_path IN VARCHAR2)
    RETURN t_values PIPELINED;
    
    FUNCTION get_string
        (p_path IN VARCHAR2)
    RETURN VARCHAR2;
    
    FUNCTION get_number
        (p_path IN VARCHAR2)
    RETURN NUMBER;
    
    FUNCTION get_boolean
        (p_path IN VARCHAR2)
    RETURN BOOLEAN;

    FUNCTION get_json
        (p_path IN VARCHAR2)
    -- @json
    RETURN VARCHAR2;
    
    FUNCTION get_json_clob
        (p_path IN VARCHAR2)
    RETURN CLOB;
    
END;
/
