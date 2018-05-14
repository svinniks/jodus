CREATE OR REPLACE TYPE t_json_builder IS OBJECT (

    id NUMBER,
    
    CONSTRUCTOR FUNCTION t_json_builder
    RETURN self AS RESULT,
    
    MEMBER FUNCTION value (
        p_value IN VARCHAR2
    )
    RETURN t_json_builder,
    
    MEMBER PROCEDURE value (
        self IN t_json_builder,
        p_value IN VARCHAR2
    ),
    
    MEMBER FUNCTION value (
        p_value IN DATE
    )
    RETURN t_json_builder,
    
    MEMBER PROCEDURE value (
        self IN t_json_builder,
        p_value IN DATE
    ),
    
    MEMBER FUNCTION value (
        p_value IN NUMBER
    )
    RETURN t_json_builder,
    
    MEMBER PROCEDURE value (
        self IN t_json_builder,
        p_value IN NUMBER
    ),
    
    MEMBER FUNCTION value (
        p_value IN BOOLEAN
    )
    RETURN t_json_builder,
    
    MEMBER PROCEDURE value (
        self IN t_json_builder,
        p_value IN BOOLEAN
    ),
    
    MEMBER FUNCTION object
    RETURN t_json_builder,
    
    MEMBER PROCEDURE object (
        self IN t_json_builder
    ),
    
    MEMBER FUNCTION name (
        p_name IN VARCHAR2
    )
    RETURN t_json_builder,
    
    MEMBER PROCEDURE name (
        self IN t_json_builder,
        p_name IN VARCHAR2
    ),
    
    MEMBER FUNCTION array
    RETURN t_json_builder,
    
    MEMBER PROCEDURE array (
        self IN t_json_builder
    ), 
    
    MEMBER FUNCTION close
    RETURN t_json_builder,
    
    MEMBER PROCEDURE close (
        self IN t_json_builder
    ),
    
    MEMBER FUNCTION build_json
    RETURN VARCHAR2,
    
    MEMBER FUNCTION build_json_clob
    RETURN CLOB
    
);