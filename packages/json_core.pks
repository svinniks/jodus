CREATE OR REPLACE PACKAGE json_core IS

    /* 
        Copyright 2018 Sergejs Vinniks

        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at
     
          http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
    */
    
    SUBTYPE BOOLEANN IS
        BOOLEAN
            NOT NULL;

    TYPE t_json_values IS 
        TABLE OF json_values%ROWTYPE;
        
    TYPE t_json_value_cache IS
        TABLE OF json_values%ROWTYPE
        INDEX BY VARCHAR2(30);
    
    TYPE t_value_cache_entry IS
        RECORD (
            next_entry_id PLS_INTEGER,
            prev_entry_id PLS_INTEGER
        );
        
    TYPE t_value_cache_entries IS
        TABLE OF t_value_cache_entry
        INDEX BY VARCHAR2(30);
        
    c_VALUE_CACHE_DEFAULT_CAPACITY CONSTANT PLS_INTEGER := 1000;
    
    TYPE t_query_element IS 
        RECORD (
            type CHAR,
            value VARCHAR2(4000),
            optional BOOLEAN,
            alias VARCHAR2(4000),
            first_child_i PLS_INTEGER,
            next_sibling_i PLS_INTEGER
        );
        
    TYPE t_query_elements IS 
        TABLE OF t_query_element;
    
    c_query_row_buffer_size CONSTANT PLS_INTEGER := 100;
    
    SUBTYPE t_value IS json_values%ROWTYPE;
    
    TYPE t_property IS 
        RECORD (
            parent_id NUMBER,
            parent_type CHAR,
            property_id NUMBER,
            property_type CHAR,
            property_name VARCHAR2(4000),
            property_locked CHAR
        );
    
    c_VALUE_QUERY CONSTANT CHAR := 'V';
    c_PROPERTY_QUERY CONSTANT CHAR := 'P';
    c_TABLE_QUERY CONSTANT CHAR := 'T';
    
    TYPE t_query_statement IS
        RECORD (
            statement VARCHAR2(32000),
            statement_clob CLOB
        );
    
    TYPE t_t_varchars IS 
        TABLE OF t_varchars;
    
    TYPE t_5_value_row IS 
        RECORD (
            value_1 VARCHAR2(4000),
            value_2 VARCHAR2(4000),
            value_3 VARCHAR2(4000),
            value_4 VARCHAR2(4000),
            value_5 VARCHAR2(4000)
        );
    
    TYPE t_5_value_table IS 
        TABLE OF t_5_value_row;
    
    TYPE t_10_value_row IS 
        RECORD (
            value_1 VARCHAR2(4000),
            value_2 VARCHAR2(4000),
            value_3 VARCHAR2(4000),
            value_4 VARCHAR2(4000),
            value_5 VARCHAR2(4000),
            value_6 VARCHAR2(4000),
            value_7 VARCHAR2(4000),
            value_8 VARCHAR2(4000),
            value_9 VARCHAR2(4000),
            value_10 VARCHAR2(4000)
        );
    
    TYPE t_10_value_table IS 
        TABLE OF t_10_value_row;
    
    TYPE t_15_value_row IS 
        RECORD (
            value_1 VARCHAR2(4000),
            value_2 VARCHAR2(4000),
            value_3 VARCHAR2(4000),
            value_4 VARCHAR2(4000),
            value_5 VARCHAR2(4000),
            value_6 VARCHAR2(4000),
            value_7 VARCHAR2(4000),
            value_8 VARCHAR2(4000),
            value_9 VARCHAR2(4000),
            value_10 VARCHAR2(4000),
            value_11 VARCHAR2(4000),
            value_12 VARCHAR2(4000),
            value_13 VARCHAR2(4000),
            value_14 VARCHAR2(4000),
            value_15 VARCHAR2(4000)
        );
    
    TYPE t_15_value_table IS 
        TABLE OF t_15_value_row;
    
    TYPE t_20_value_row IS 
        RECORD (
            value_1 VARCHAR2(4000),
            value_2 VARCHAR2(4000),
            value_3 VARCHAR2(4000),
            value_4 VARCHAR2(4000),
            value_5 VARCHAR2(4000),
            value_6 VARCHAR2(4000),
            value_7 VARCHAR2(4000),
            value_8 VARCHAR2(4000),
            value_9 VARCHAR2(4000),
            value_10 VARCHAR2(4000),
            value_11 VARCHAR2(4000),
            value_12 VARCHAR2(4000),
            value_13 VARCHAR2(4000),
            value_14 VARCHAR2(4000),
            value_15 VARCHAR2(4000),
            value_16 VARCHAR2(4000),
            value_17 VARCHAR2(4000),
            value_18 VARCHAR2(4000),
            value_19 VARCHAR2(4000),
            value_20 VARCHAR2(4000)
        );
    
    TYPE t_20_value_table IS 
        TABLE OF t_20_value_row;
    
    /* Generic JSON value parse event constant functions */
    
    FUNCTION string_events (
        p_value IN VARCHAR2
    )
    RETURN json_parser.t_parse_events;
    
    FUNCTION date_events (
        p_value IN DATE
    )
    RETURN json_parser.t_parse_events;
    
    FUNCTION number_events (
        p_value IN NUMBER
    )
    RETURN json_parser.t_parse_events;
    
    FUNCTION boolean_events (
        p_value IN BOOLEAN
    )
    RETURN json_parser.t_parse_events;
    
    FUNCTION null_events
    RETURN json_parser.t_parse_events;
    
    FUNCTION object_events
    RETURN json_parser.t_parse_events;
    
    FUNCTION array_events
    RETURN json_parser.t_parse_events;
    
    /* Value cache management methods */
    
    PROCEDURE reset_value_cache;
    
    FUNCTION get_cached_values
    RETURN t_json_values PIPELINED;
    
    PROCEDURE set_value_cache_capacity (
        p_capacity IN PLS_INTEGER
    );
    
    FUNCTION get_value (
        p_id IN NUMBER
    )
    RETURN t_value;
    
    /* JSON query API methods */
    
    FUNCTION parse_query (
        p_query IN VARCHAR2
    ) 
    RETURN t_query_elements;
    
    FUNCTION parse_path (
        p_path IN VARCHAR2
    ) 
    RETURN t_query_elements;
    
    FUNCTION get_query_signature (
        p_query_elements IN t_query_elements
    )
    RETURN VARCHAR2;
    
    FUNCTION get_query_column_names (
        p_query_elements IN t_query_elements
    )
    RETURN t_varchars;
    
    FUNCTION get_query_bind_numbers (
        p_query_elements IN t_query_elements
    )
    RETURN t_numbers;
    
    FUNCTION get_query_constants (
        p_query_elements IN t_query_elements
    )
    RETURN t_varchars;
    
    FUNCTION get_query_statement (
        p_query_elements IN t_query_elements,
        p_query_type IN CHAR,
        p_column_count IN PLS_INTEGER := NULL
    )
    RETURN t_query_statement;  
    
    FUNCTION prepare_query (
        p_query_elements IN t_query_elements,
        p_query_statement IN t_query_statement,
        p_bind IN bind
    )
    RETURN INTEGER;
    
    FUNCTION to_refcursor (
        p_cursor_id IN INTEGER
    )
    RETURN SYS_REFCURSOR;
        
    /* Generic methods for JSON value retrieval and serialization */
    
    FUNCTION request_value (
        p_path IN VARCHAR2,
        p_bind IN bind,
        p_raise_not_found IN BOOLEAN := FALSE
    ) 
    RETURN NUMBER;
    
    FUNCTION request_value (
        p_parent_value_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind,
        p_raise_not_found IN BOOLEAN := FALSE
    ) 
    RETURN NUMBER;
    
    FUNCTION request_property (
        p_parent_value_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind
    ) 
    RETURN t_property;
    
    PROCEDURE get_parse_events (
        p_value_id IN NUMBER,
        p_parse_events OUT json_parser.t_parse_events
    ); 
    
    FUNCTION escape_string (
        p_string IN VARCHAR2
    )
    RETURN VARCHAR2;
    
    PROCEDURE serialize_value (
        p_parse_events IN json_parser.t_parse_events,
        p_serialize_nulls IN BOOLEANN,
        p_json IN OUT NOCOPY VARCHAR2,
        p_json_clob IN OUT NOCOPY CLOB
    );
    
    /* Cached value casting to the scalar types and JSON */
    
    FUNCTION get_string (
        p_value_id IN NUMBER
    ) 
    RETURN VARCHAR2;
    
    FUNCTION get_date (
        p_value_id IN NUMBER
    )
    RETURN DATE;
    
    FUNCTION get_number (
        p_value_id IN NUMBER
    ) 
    RETURN NUMBER;
    
    FUNCTION get_boolean (
        p_value_id IN NUMBER
    ) 
    RETURN BOOLEAN;
    
    FUNCTION get_json (
        p_value_id IN NUMBER,
        p_serialize_nulls IN BOOLEANN
    ) 
    RETURN VARCHAR2;
    
    FUNCTION get_json_clob (
        p_value_id IN NUMBER,
        p_serialize_nulls IN BOOLEANN
    ) 
    RETURN CLOB;
    
    FUNCTION get_strings (
        p_value_id IN NUMBER
    ) 
    RETURN t_varchars;
    
    FUNCTION get_numbers (
        p_value_id IN NUMBER
    )
    RETURN t_numbers;
    
    /* Some usefull generic methods */
    
    FUNCTION is_string (
        p_value_id IN NUMBER
    )
    RETURN BOOLEAN;
    
    FUNCTION is_date (
        p_value_id IN NUMBER
    )
    RETURN BOOLEAN;
    
    FUNCTION is_number (
        p_value_id IN NUMBER
    )
    RETURN BOOLEAN;
    
    FUNCTION is_boolean (
        p_value_id IN NUMBER
    )
    RETURN BOOLEAN;
    
    FUNCTION is_null (
        p_value_id IN NUMBER
    )
    RETURN BOOLEAN;
    
    FUNCTION is_object (
        p_value_id IN NUMBER
    )
    RETURN BOOLEAN;
    
    FUNCTION is_array (
        p_value_id IN NUMBER
    )
    RETURN BOOLEAN;
    
    /* Special object methods */
    
    FUNCTION get_keys (
        p_object_id IN NUMBER
    )
    RETURN t_varchars;
    
    /* Special array methods */
    
    FUNCTION get_length (
        p_array_id IN NUMBER
    )
    RETURN NUMBER;
    
    FUNCTION index_of (
        p_array_id IN NUMBER,
        p_value IN VARCHAR2,
        p_from_index IN NUMBER
    ) 
    RETURN NUMBER;
    
    FUNCTION index_of (
        p_array_id IN NUMBER,
        p_value IN DATE,
        p_from_index IN NUMBER
    ) 
    RETURN NUMBER;
    
    FUNCTION index_of (
        p_array_id IN NUMBER,
        p_value IN NUMBER,
        p_from_index IN NUMBER
    ) 
    RETURN NUMBER;
    
    FUNCTION index_of (
        p_array_id IN NUMBER,
        p_value IN BOOLEAN,
        p_from_index IN NUMBER
    ) 
    RETURN NUMBER;
    
    FUNCTION index_of_null (
        p_array_id IN NUMBER,
        p_from_index IN NUMBER
    ) 
    RETURN NUMBER;
    
    /* JSON creation, modification and deletion methods */
    
    FUNCTION create_json (
        p_content_parse_events IN json_parser.t_parse_events
    ) 
    RETURN NUMBER;
        
    FUNCTION set_property (
        p_path IN VARCHAR2,
        p_bind IN bind,
        p_content_parse_events IN json_parser.t_parse_events
    )
    RETURN NUMBER;
    
    FUNCTION set_property (
        p_parent_value_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind,
        p_content_parse_events IN json_parser.t_parse_events
    )
    RETURN NUMBER;
    
    FUNCTION push_json (
        p_array_id IN NUMBER,
        p_content_parse_events IN json_parser.t_parse_events
    )
    RETURN NUMBER;
    
    FUNCTION apply_json (
        p_value_id IN NUMBER,
        p_content_parse_events json_parser.t_parse_events,
        p_check_types IN BOOLEAN
    )
    RETURN NUMBER;
    
    PROCEDURE delete_value (
        p_value_id IN NUMBER
    );
    
    /* Value pinning/unpinning methods */
    
    PROCEDURE pin (
        p_value_id IN NUMBER,
        p_pin_tree IN BOOLEAN
    );
    
    PROCEDURE unpin (
        p_value_id IN NUMBER,
        p_unpin_tree IN BOOLEAN
    );
    
END;
