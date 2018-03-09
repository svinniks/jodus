CREATE OR REPLACE VIEW json_data_registered_types AS
SELECT value_1 AS name,
       value_2 AS ignore_unknown
FROM TABLE(json_store.get_5_value_table(json_data_generator.get_type_register_path || '.*(.name,.ignoreUnknown)'))