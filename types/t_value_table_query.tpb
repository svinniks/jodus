CREATE OR REPLACE TYPE BODY t_value_table_query IS

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
    
    CONSTRUCTOR FUNCTION t_value_table_query (
        p_row_type ANYTYPE
    ) 
    RETURN SELF AS RESULT IS
    BEGIN
    
        row_type := p_row_type;
        
        RETURN;
    
    END;
    
    STATIC FUNCTION odcitablestart ( 
        p_context IN OUT t_value_table_query,
        p_query IN VARCHAR2,
        p_bind IN bind
    ) 
    RETURN PLS_INTEGER IS
    
        v_columns DBMS_SQL.DESC_TAB;
    
    BEGIN
        
        p_context.cursor_id := json_store.prepare_query(
            p_query,
            p_bind,
            json_store.c_VALUE_TABLE_QUERY
        );
        
        DBMS_SQL.DESCRIBE_COLUMNS(p_context.cursor_id, p_context.column_count, v_columns); 
        
        p_context.fetched_row_count := NULL;
        p_context.piped_row_count := 0;
        
        p_context.row_buffer := t_varchars();
        p_context.row_buffer.EXTEND(p_context.column_count * json_store.c_query_row_buffer_size);
        
        RETURN odciconst.success;
    
    END;
    
    STATIC FUNCTION odcitabledescribe (
        p_return_type OUT ANYTYPE,
        p_query IN VARCHAR2,
        p_bind IN bind
    ) 
    RETURN PLS_INTEGER IS
        
        v_query_elements json_store.t_query_elements;
        v_query_statement json_store.t_query_statement;
        v_query_column_names t_varchars;
        
        v_row_type ANYTYPE;
        
    BEGIN
        
        v_query_elements := json_store.parse_query(p_query, json_store.c_VALUE_TABLE_QUERY);
        v_query_column_names := json_store.get_query_column_names(v_query_elements);
        
        ANYTYPE.begincreate(DBMS_TYPES.TYPECODE_OBJECT, v_row_type);
        
        FOR v_i IN 1..v_query_column_names.COUNT LOOP
            v_row_type.addattr(v_query_column_names(v_i), DBMS_TYPES.TYPECODE_VARCHAR2, NULL, NULL, 4000, NULL, NULL);
        END LOOP;
            
        v_row_type.endcreate;
            
        ANYTYPE.begincreate(DBMS_TYPES.TYPECODE_NAMEDCOLLECTION, p_return_type);
        p_return_type.setinfo(NULL, NULL, NULL, NULL, NULL, v_row_type, DBMS_TYPES.TYPECODE_OBJECT, 0);
        p_return_type.endcreate;
    
        RETURN odciconst.success;
    
    END;
    
    STATIC FUNCTION odcitableprepare (
        p_context OUT t_value_table_query,
        p_table_function_info IN sys.odcitabfuncinfo,
        p_query IN VARCHAR2,
        p_bind IN bind
    ) 
    RETURN PLS_INTEGER IS
    
        v_return NUMBER;
        v_precision PLS_INTEGER;
        v_scale PLS_INTEGER;
        v_length PLS_INTEGER;
        v_cs_id PLS_INTEGER;
        v_cs_frm PLS_INTEGER;
        v_row_type ANYTYPE;    
        v_name VARCHAR2(30);
    
    BEGIN
    
        v_return := p_table_function_info.rettype.getattreleminfo(
            1
           ,v_precision
           ,v_scale
           ,v_length
           ,v_cs_id
           ,v_cs_frm
           ,v_row_type
           ,v_name
        );
    
        p_context := t_value_table_query(v_row_type);
    
        RETURN odciconst.success;
    
    END;
             
    MEMBER FUNCTION fetch_row(
        self IN OUT NOCOPY t_value_table_query,
        p_row IN OUT NOCOPY t_varchars
    ) 
    RETURN BOOLEAN IS
        
        v_column_values DBMS_SQL.VARCHAR2_TABLE;
        
    BEGIN
    
        IF fetched_row_count IS NULL OR fetched_row_count = piped_row_count THEN
            
            IF fetched_row_count IS NOT NULL AND piped_row_count < json_store.c_query_row_buffer_size THEN
                RETURN FALSE;
            END IF;
            
            FOR v_i IN 1..column_count LOOP
                DBMS_SQL.DEFINE_ARRAY(cursor_id, v_i, v_column_values, json_store.c_query_row_buffer_size, 1);
            END LOOP;
            
            piped_row_count := 0;
            fetched_row_count := DBMS_SQL.FETCH_ROWS(cursor_id);
                
            IF fetched_row_count = 0 THEN
                RETURN FALSE;
            END IF;
                
            FOR v_i IN 1..column_count LOOP
                
                DBMS_SQL.COLUMN_VALUE(cursor_id, v_i, v_column_values);
                    
                FOR v_j IN 1..fetched_row_count LOOP
                    row_buffer((v_i - 1) * json_store.c_query_row_buffer_size + v_j) := v_column_values(v_j);
                END LOOP;
                    
            END LOOP;   
                
        END IF;
        
        piped_row_count := piped_row_count + 1;
        
        FOR v_i IN 1..LEAST(column_count, p_row.COUNT) LOOP
            p_row(v_i) := row_buffer((v_i - 1) * json_store.c_query_row_buffer_size + piped_row_count);
        END LOOP;
        
        RETURN TRUE;
    
    END;
    
    
    MEMBER FUNCTION odcitablefetch (
        self IN OUT NOCOPY t_value_table_query,
        p_row_count IN NUMBER,
        p_dataset OUT ANYDATASET
    ) 
    RETURN PLS_INTEGER IS
        
        v_row t_varchars;
        
    BEGIN
    
        v_row := t_varchars();
        v_row.extend(column_count);
        
        FOR v_i IN 1..p_row_count LOOP
        
            IF fetch_row(v_row) THEN
            
                IF p_dataset IS NULL THEN
                    ANYDATASET.begincreate(DBMS_TYPES.TYPECODE_OBJECT, row_type, p_dataset);
                END IF;         
            
                p_dataset.addinstance;          
                p_dataset.piecewise;
                
                FOR v_i IN 1..column_count LOOP
                    p_dataset.setvarchar2(v_row(v_i), v_i = column_count);
                END LOOP;
            
            ELSE
            
                EXIT;
            
            END IF;
        
        END LOOP;
        
        IF p_dataset IS NOT NULL THEN
        
            p_dataset.endcreate;
            
        ELSE 
        
            DBMS_SQL.CLOSE_CURSOR(cursor_id);
            
        END IF;
        
        RETURN odciconst.success;
    
    END;
    
    MEMBER FUNCTION odcitableclose (
        self IN t_value_table_query
    ) 
    RETURN PLS_INTEGER IS
    
        v_cursor_id INTEGER;
    
    BEGIN

        IF cursor_id IS NOT NULL THEN
            v_cursor_id := cursor_id;
            DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
        END IF;

        RETURN odciconst.success;
    
    END;
    

END;