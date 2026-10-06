{% macro mask_user_id (column_name, salt='1234') -%}
    
    to_hex(sha256(concat(cast({{ column_name }} as string), '{{ salt }}')))

{%- endmacro %}