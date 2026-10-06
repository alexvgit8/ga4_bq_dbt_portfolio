-- applies the channels() macro to classify each event's source/medium pair into a marketing channel
select
    *,
    {{ channels('source', 'medium') }} as channels
from {{ ref('stg_ga4__events') }}
