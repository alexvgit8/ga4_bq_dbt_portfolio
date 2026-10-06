-- how each marketing channel performing overall
select
    channels,
    count(distinct concat(masked_user_id, cast(ga_session_id as string))) as sessions,
    count(distinct transaction_id) as transactions,
    round(count(distinct transaction_id) / count(distinct concat(masked_user_id, cast(ga_session_id as string))) * 100, 2) as conv_rate
from {{ ref('int_channels') }}
group by 1
order by conv_rate desc