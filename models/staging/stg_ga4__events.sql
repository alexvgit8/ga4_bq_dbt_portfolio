-- reads the public GA4 source, unnests `event_params`, replaces GA4's placeholder values (`'(data deleted)'`) with `NULL`, hashes `user_pseudo_id` into `masked_user_id`
SELECT
    {{ mask_user_id("user_pseudo_id")}} AS masked_user_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as ga_session_id,
    event_date as date,
    event_name AS event,
    {{ data_deleted_to_null("traffic_source.source")}} AS source,
    {{ data_deleted_to_null("traffic_source.medium")}} AS medium,
    ecommerce.transaction_id AS transaction_id,
    ecommerce.purchase_revenue AS revenue,
    ecommerce.total_item_quantity  AS item_qty
FROM {{ source('ga4', 'ga_events') }}
    WHERE _TABLE_SUFFIX BETWEEN '{{ var('ga4_start_date') }}' AND '{{ var('ga4_end_date') }}'
    
