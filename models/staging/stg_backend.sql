-- reads the synthetic backend table from BQ, hashes the same user key so it can later be joined against GA4 data
SELECT
    {{ mask_user_id("user_pseudo_id")}} AS masked_user_id,
    signup_date,
    plan_type,
    lifetime_value,
    user_segment,
    marketing_opt_in
FROM  {{ source('backend', 'raw_backend_users') }}