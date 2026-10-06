-- how does each individual user's activity break down across channels
SELECT
    a.masked_user_id,
    channels,
    count(distinct concat(ga.masked_user_id, cast(ga_session_id as string))) as total_sessions,
    count(distinct transaction_id) as total_transactions
FROM {{ ref('stg_backend') }} a
LEFT JOIN {{ ref('int_channels') }} ga
ON a.masked_user_id = ga.masked_user_id
GROUP BY
    1,2