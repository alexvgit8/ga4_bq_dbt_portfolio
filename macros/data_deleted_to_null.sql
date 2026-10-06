{%- macro data_deleted_to_null(column_name) -%}

    nullif({{ column_name }}, '(data deleted)')

{%- endmacro %}