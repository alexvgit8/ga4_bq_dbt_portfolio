{% macro channels (source = 'source', medium = 'medium') -%}
    CASE
        WHEN {{ source }} = '(direct)' AND {{ medium }} = '(none)' THEN 'Direct'
        WHEN {{ medium }} = 'organic' THEN 'Organic Search'
        WHEN {{ medium }} IN ('cpc', 'ppc', 'paidsearch') AND {{ source }} like '%google%' THEN 'Paid Search'
        WHEN regexp_contains(lower({{ source }}), r'facebook|instagram|linkedin|twitter|tiktok') THEN 'Paid Social'
        WHEN {{ medium }} = 'email' THEN 'Email'
        WHEN {{ medium }} = 'referral' THEN 'Referral'
        WHEN {{ medium }} IS NULL AND {{ source }} IS NULL THEN '(not set)'
        ELSE 'Unassigned'
    END

{%- endmacro %}