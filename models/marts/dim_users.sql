-- data for each user grain, join backend attributes with web GA4 behavior (only first touch attribution)
with events as (
    select * from {{ ref('int_channels') }}
),

activity as (
    select
        masked_user_id,
        count(distinct concat(masked_user_id, cast(ga_session_id as string))) as total_sessions,
        count(distinct transaction_id)  as total_transactions
    from events
    group by masked_user_id
),

first_touch as (
    select
        masked_user_id,
        channels as acquisition_channel
    from events
    qualify row_number() over (partition by masked_user_id order by date, ga_session_id) = 1
),

backend as (
    select * from {{ ref('stg_backend') }}
)

select
    backend.masked_user_id,
    backend.signup_date,
    backend.plan_type,
    backend.lifetime_value,
    backend.user_segment,
    backend.marketing_opt_in,
    first_touch.acquisition_channel,
    coalesce(activity.total_sessions, 0)     as total_sessions,
    coalesce(activity.total_transactions, 0) as total_transactions
from backend
left join activity    using (masked_user_id)
left join first_touch using (masked_user_id)