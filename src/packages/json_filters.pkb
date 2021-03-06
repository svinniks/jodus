CREATE OR REPLACE PACKAGE BODY json_filters IS
    
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

    v_filters t_json_filters;

    v_unused_filter_ids t_integers := t_integers();

    PROCEDURE register_messages IS
    BEGIN
        default_message_resolver.register_message('JFR-00001', 'JSON filter ID not specified!');
        default_message_resolver.register_message('JFR-00002', 'Invalid JSON filter!');
        default_message_resolver.register_message('JFR-00003', 'JSON filter is incomplete!');
        default_message_resolver.register_message('JFR-00004', 'Unexpected filter path!');
        default_message_resolver.register_message('JFR-00005', 'Unexpected filter value!');
        default_message_resolver.register_message('JFR-00006', 'Anchors and bind variables are not allowed in filters!');
        default_message_resolver.register_message('JFR-00007', 'NULL filter value specified!');
    END;

    FUNCTION create_filter (
        p_base_value_id IN NUMBER
    )
    RETURN PLS_INTEGER IS
    
        v_base_value json_core.t_json_value;
        v_id PLS_INTEGER;
        
    BEGIN
    
        v_base_value := persistent_json_store.get_value(p_base_value_id);
        
        IF v_unused_filter_ids.COUNT > 0 THEN
            v_id := v_unused_filter_ids(v_unused_filter_ids.COUNT);
            v_unused_filter_ids.TRIM(1);
        ELSE
            v_id := NVL(v_filters.LAST, 0) + 1;
        END IF;
        
        v_filters(v_id).base_value_id := p_base_value_id;
        v_filters(v_id).criterias := t_filter_criterias();
        v_filters(v_id).state := 'lf_first_path';
        
        RETURN v_id;
    
    END;
    
    PROCEDURE check_filter (
        p_id IN PLS_INTEGER
    ) IS
    BEGIN
    
        IF p_id IS NULL THEN
            -- JSON filter ID not specified!
            error$.raise('JFR-00001');
        ELSIF NOT v_filters.EXISTS(p_id) THEN
            -- Invalid JSON filter!
            error$.raise('JFR-00002');
        END IF;
    
    END;
    
    PROCEDURE path (
        p_filter_id IN PLS_INTEGER,
        p_path IN VARCHAR2
    ) IS
        
        v_path_element_i PLS_INTEGER;
        v_path STRING;
        v_depth PLS_INTEGER;
    
    BEGIN
    
        check_filter(p_filter_id);
        
        IF v_filters(p_filter_id).state NOT IN ('lf_first_path', 'lf_path') THEN
            -- Unexpected filter path!
            error$.raise('JFR-00004');
        END IF;
        
        v_path_element_i := json_core.parse_path(p_path, TRUE);
        v_path_element_i := json_core.v_query_elements(v_path_element_i).first_child_i; 
        v_depth := 0;
        
        WHILE v_path_element_i IS NOT NULL LOOP
        
            v_depth := v_depth + 1;
        
            IF json_core.v_query_elements(v_path_element_i).type IN ('I', ':', '#') THEN
                -- Bind variables are not allowed in filters!
                error$.raise('JFR-00006');
            END IF;
        
            v_path := v_path || '["' || REPLACE(json_core.v_query_elements(v_path_element_i).value, '"', '\"') || '"]';
            
            v_path_element_i := json_core.v_query_elements(v_path_element_i).first_child_i; 
            
        END LOOP;
        
        v_filters(p_filter_id).criterias.EXTEND(1);
        v_filters(p_filter_id).criterias(v_filters(p_filter_id).criterias.COUNT).path := v_path;
        v_filters(p_filter_id).criterias(v_filters(p_filter_id).criterias.COUNT).depth := v_depth;
        
        v_filters(p_filter_id).state := 'lf_value';
    
    END;
    
    PROCEDURE value (
        p_filter_id IN PLS_INTEGER,
        p_value IN VARCHAR2
    ) IS
        v_value STRING;
    BEGIN
    
        check_filter(p_filter_id);
        
        IF v_filters(p_filter_id).state != 'lf_value' THEN
            -- Unexpected filter value!
            error$.raise('JFR-00005');
        END IF;
    
        v_value := UPPER(TRIM(p_value));
        
        IF v_value IS NULL THEN
            -- NULL filter value specified
            error$.raise('JFR-00007');
        END IF;
    
        v_filters(p_filter_id).criterias(v_filters(p_filter_id).criterias.COUNT).value := UPPER(v_value);
        
        v_filters(p_filter_id).state := 'lf_path';
        
    END;
    
    PROCEDURE value (
        p_filter_id IN PLS_INTEGER,
        p_value IN NUMBER
    ) IS
    BEGIN
        value(p_filter_id, json_core.to_json_char(p_value));
    END;
    
    PROCEDURE value (
        p_filter_id IN PLS_INTEGER,
        p_value IN DATE
    ) IS
    BEGIN
        value(p_filter_id, json_core.to_json_char(p_value));
    END;
    
    PROCEDURE value (
        p_filter_id IN PLS_INTEGER,
        p_value IN BOOLEAN
    ) IS
    BEGIN
        value(p_filter_id, json_core.to_json_char(p_value));
    END;
    
    PROCEDURE check_complete_filter (
        p_filter_id IN PLS_INTEGER
    ) IS
    BEGIN
    
        check_filter(p_filter_id);
    
        IF v_filters(p_filter_id).state != 'lf_path' THEN
            -- JSON filter is incomplete!
            error$.raise('JFR-00003');
        END IF;
    
    END;
    
    FUNCTION criterias (
        p_filter_id IN PLS_INTEGER
    )
    RETURN t_filter_criterias PIPELINED IS
    BEGIN
    
        check_complete_filter(p_filter_id);
    
        FOR v_i IN 1..v_filters(p_filter_id).criterias.COUNT LOOP
            PIPE ROW(v_filters(p_filter_id).criterias(v_i));
        END LOOP;
        
        RETURN;
    
    END;
    
    PROCEDURE delete_filter (
        p_filter_id IN PLS_INTEGER
    ) IS
    BEGIN
    
        v_filters.DELETE(p_filter_id);
        
        v_unused_filter_ids.EXTEND(1);
        v_unused_filter_ids(v_unused_filter_ids.COUNT) := p_filter_id;
    
    END;
    
    FUNCTION execute (
        p_filter_id IN PLS_INTEGER
    )
    RETURN t_json_properties IS
    
        CURSOR c_properties (
            p_criteria_count IN NUMBER
        ) IS
            WITH jsvl(id, parent_id, name, depth, path, criteria_depth, criteria_path) AS
                (SELECT /* INDEX(jsvl, jsvl_i3) */
                        id,
                        parent_id,
                        name,
                        1,
                        '["' || REPLACE(name, '"', '\"') || '"]',
                        crit.depth,
                        crit.path
                 FROM TABLE(criterias(p_filter_id)) crit,
                      json_values jsvl
                 WHERE UPPER(TRIM(jsvl.value)) LIKE crit.value
                 UNION ALL
                 SELECT parent.id,
                        parent.parent_id,
                        parent.name,
                        depth + 1,
                        DECODE(depth, criteria_depth, NULL, '["' || REPLACE(parent.name, '"', '\"') || '"]') || path,
                        criteria_depth,
                        criteria_path
                 FROM jsvl,
                      json_values parent
                 WHERE parent.id = jsvl.parent_id
                       AND depth <= criteria_depth)
            SELECT /*+ FIRST_ROWS */
                   t_json_property(id, name)
            FROM jsvl
            WHERE depth = criteria_depth + 1
                  AND path = criteria_path
                  AND parent_id = v_filters(p_filter_id).base_value_id
            GROUP BY id,
                     name
            HAVING COUNT(*) = p_criteria_count;
            
        v_properties t_json_properties;
        
    BEGIN
        
        check_complete_filter(p_filter_id);
    
        OPEN c_properties(v_filters(p_filter_id).criterias.COUNT);
        
        FETCH c_properties
        BULK COLLECT INTO v_properties;
            
        CLOSE c_properties;
        
        delete_filter(p_filter_id);
        
        RETURN v_properties;
       
    END;        
    
BEGIN    
    register_messages;
END;
