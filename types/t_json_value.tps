CREATE OR REPLACE TYPE t_json_value IS OBJECT (

    id NUMBER,
    parent_id NUMBER,
    type CHAR,
    value VARCHAR2(4000),
    
    STATIC FUNCTION create_object
    RETURN t_json_value,
    
    STATIC FUNCTION create_array
    RETURN t_json_value,
    
    STATIC FUNCTION create_json (
        p_content IN VARCHAR2
    )
    RETURN t_json_value,
    
    STATIC FUNCTION create_json (
        p_content IN CLOB
    )
    RETURN t_json_value,
    
    STATIC FUNCTION request_value (
        p_anchor_value_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    CONSTRUCTOR FUNCTION t_json_value (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN self AS RESULT,
    
    CONSTRUCTOR FUNCTION t_json_value (
        p_anchor_value_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN self AS RESULT,
    
    CONSTRUCTOR FUNCTION t_json_value (
        p_id IN NUMBER
    ) RETURN self AS RESULT,
    
    MEMBER FUNCTION as_string
    RETURN VARCHAR2,
    
    MEMBER FUNCTION as_number
    RETURN NUMBER,
    
    MEMBER FUNCTION as_boolean
    RETURN BOOLEAN,
    
    MEMBER FUNCTION get_parent
    RETURN t_json_value,

    MEMBER FUNCTION get_keys
    RETURN t_varchars,
    
    MEMBER FUNCTION get_length (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    )
    RETURN PLS_INTEGER,
    
    MEMBER FUNCTION get_length
    RETURN PLS_INTEGER,
    
    MEMBER FUNCTION is_object
    RETURN BOOLEAN,
    
    MEMBER FUNCTION is_array
    RETURN BOOLEAN,
    
    MEMBER FUNCTION has (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) 
    RETURN BOOLEAN,
        
    MEMBER FUNCTION get (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    )
    RETURN t_json_value,
    
    MEMBER FUNCTION get_string (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    )
    RETURN VARCHAR2,
    
    MEMBER FUNCTION get_number (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    )
    RETURN NUMBER,
    
    MEMBER FUNCTION get_boolean (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    )
    RETURN BOOLEAN,
    
    MEMBER FUNCTION set_string (
        p_path IN VARCHAR2,
        p_value IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_string (
        p_path IN VARCHAR2,
        p_value IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION set_number (
        p_path IN VARCHAR2,
        p_value IN NUMBER,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_number (
        p_path IN VARCHAR2,
        p_value IN NUMBER,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION set_boolean (
        p_path IN VARCHAR2,
        p_value IN BOOLEAN,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_boolean (
        p_path IN VARCHAR2,
        p_value IN BOOLEAN,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION set_object (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_object (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION set_array (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_array (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION set_null (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_null (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION set_json (
        p_path IN VARCHAR2,
        p_content IN VARCHAR2,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_json (
        p_path IN VARCHAR2,
        p_content IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION set_json (
        p_path IN VARCHAR2,
        p_content IN CLOB,
        p_bind IN bind := NULL
    ) RETURN t_json_value,
    
    MEMBER PROCEDURE set_json (
        p_path IN VARCHAR2,
        p_content IN CLOB,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_string (
        p_path IN VARCHAR2,
        p_value IN VARCHAR2,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_string (
        p_path IN VARCHAR2,
        p_value IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_string (
        p_value IN VARCHAR2
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_string (
        p_value IN VARCHAR2
    ),
    
    MEMBER FUNCTION push_number (
        p_path IN VARCHAR2,
        p_value IN NUMBER,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_number (
        p_path IN VARCHAR2,
        p_value IN NUMBER,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_number (
        p_value IN NUMBER
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_number (
        p_value IN NUMBER
    ),
    
    MEMBER FUNCTION push_boolean (
        p_path IN VARCHAR2,
        p_value IN BOOLEAN,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_boolean (
        p_path IN VARCHAR2,
        p_value IN BOOLEAN,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_boolean (
        p_value IN BOOLEAN
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_boolean (
        p_value IN BOOLEAN
    ),
    
    MEMBER FUNCTION push_object (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_object (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_object
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_object,
    
    MEMBER FUNCTION push_array (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_array (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_array
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_array,
    
    MEMBER FUNCTION push_null (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_null (
        p_path IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_null
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_null,
    
    MEMBER FUNCTION push_json (
        p_path IN VARCHAR2,
        p_content IN VARCHAR2,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_json (
        p_path IN VARCHAR2,
        p_content IN VARCHAR2,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_json (
        p_content IN VARCHAR2
    )
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_json (
        p_content IN VARCHAR2
    ),
    
    MEMBER FUNCTION push_json (
        p_path IN VARCHAR2,
        p_content IN CLOB,
        p_bind IN bind := NULL
    ) 
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_json (
        p_path IN VARCHAR2,
        p_content IN CLOB,
        p_bind IN bind := NULL
    ),
    
    MEMBER FUNCTION push_json (
        p_content IN CLOB
    )
    RETURN t_json_value,
    
    MEMBER PROCEDURE push_json (
        p_content IN CLOB
    )
    
);