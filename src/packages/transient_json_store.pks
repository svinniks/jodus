CREATE OR REPLACE PACKAGE transient_json_store IS

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
            
    TYPE t_property IS 
        RECORD (
            parent_id NUMBER,
            parent_type CHAR,
            property_id NUMBER,
            property_type CHAR,
            property_name VARCHAR2(4000),
            property_locked CHAR
        );
    
    v_values json_core.t_json_values;
    
    FUNCTION get_value (
        p_id IN NUMBER
    )
    RETURN json_core.t_json_value;
    
    FUNCTION dump_value (
        p_id IN NUMBER
    )
    RETURN json_core.t_json_values; 
    
    -- Generic methods for JSON value retrieval and serialization
    
    FUNCTION request_value (
        p_anchor_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind,
        p_raise_not_found IN BOOLEAN := FALSE
    ) 
    RETURN NUMBER;
    
    FUNCTION request_property_value (
        p_parent_id IN NUMBER,
        p_name IN VARCHAR2
    )
    RETURN NUMBER;
    
    FUNCTION request_property (
        p_anchor_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind
    ) 
    RETURN t_property;
    
    FUNCTION get_parse_events (
        p_value_id IN NUMBER,
        p_serialize_nulls IN BOOLEAN
    )
    RETURN t_varchars; 
    
    -- Special object methods
    
    FUNCTION get_keys (
        p_object_id IN NUMBER
    )
    RETURN t_varchars;
    
    -- Special array methods
    
    FUNCTION get_length (
        p_array_id IN NUMBER
    )
    RETURN NUMBER;
    
    FUNCTION get_raw_values (
        p_array_id IN NUMBER,
        p_type IN CHAR
    )
    RETURN t_varchars;
    
    FUNCTION index_of (
        p_array_id IN NUMBER,
        p_type IN VARCHAR2,
        p_value IN VARCHAR2,
        p_from_index IN NUMBER
    )
    RETURN NUMBER;
        
    -- JSON creation, modification and deletion methods
    
    FUNCTION create_json (
        p_content_parse_events IN t_varchars
    ) 
    RETURN NUMBER;
    
    FUNCTION create_json (
        p_parent_id IN NUMBER,
        p_parent_type IN CHAR,
        p_name IN VARCHAR2,
        p_content_parse_events IN t_varchars,
        p_event_i IN PLS_INTEGER := 1
    ) 
    RETURN NUMBER;
    
    FUNCTION set_property (
        p_anchor_id IN NUMBER,
        p_path IN VARCHAR2,
        p_bind IN bind,
        p_content_parse_events IN t_varchars
    )
    RETURN NUMBER;
    
    PROCEDURE delete_value (
        p_id IN NUMBER
    );
    
    -- Value locking/unlocking methods
    
    PROCEDURE pin_value (
        p_id IN NUMBER,
        p_pin_tree IN BOOLEAN
    );
    
    PROCEDURE unpin_value (
        p_id IN NUMBER,
        p_unpin_tree IN BOOLEAN
    );
    
    -- Table query execution
    
    PROCEDURE execute_table_query (
        p_anchor_id IN NUMBER,
        p_query IN VARCHAR2,
        p_bind IN bind,
        p_values OUT t_varchars,
        p_column_count OUT PLS_INTEGER 
    );
    
END;
