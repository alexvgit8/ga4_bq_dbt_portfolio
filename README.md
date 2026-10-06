# GA4 + dbt + BigQuery Portfolio

A small analytics engineering project built on Google's public GA4 sample e-commerce dataset, combined with synthetic backend user data.
From raw source to BI-ready marts — with PII masking, 3 reusable Jinja macros and tests.

## Data sources

bigquery-public-data.ga4_obfuscated_sample_ecommerce — Google's public GA4 sample dataset with web users data.
raw_backend_users — a synthetic "backend" table I generated with a help of LLM, keyed on the same `user_pseudo_id` values as the GA4 sample, simulating what a real backend users table might look like (plan type, lifetime value, user segment, marketing opt-in, signup date).

The two are joined in "dim_users" model to show what a blended web-analytics + backend-data model looks like — a common real-world request from marketing departments I received many times in my career.

## Models

staging/ - clean, 1:1 with source, no business logic
intermediate/ - business logic that multiple marts reuse (channel classification)
marts/ - final BI-ready models, one per analytical question

### Staging

stg_ga4\_\_events (one event grain) - reads the public GA4 source, unnests `event_params`, replaces GA4's hidden values (data deleted) with `NULL`, hashes `user_pseudo_id` into `masked_user_id`
stg_backend (one user grain) - reads the synthetic backend table from BQ, hashes the same user key so it can later be joined against GA4 data

### Intermediate

int_channels (one event grain) - applies the channels() macro to classify each event's source/medium pair into a marketing channel

### Marts

dim_users (one user grain) - data for each user grain, join backend attributes with web GA4 behavior (only first touch attribution)
fct_channel_performance (one channel grain) - how each marketing channel performing overall
fct_user_channel_activity (one user per channel grain) - how does each individual user's activity break down across channels

## Macros

channels - defining marketing channels as a pair of source/medium values
data_deleted_to_null - transforming (data deleted) values in GA4 sample table to native NULL values
mask_user_id - `user_pseudo_id` is hashed (`SHA256` + salt) in staging. On prod all IDs better to be hashed.

## Testing

- `not_null` / `unique` on primary keys across staging and marts (`masked_user_id`, `ga_session_id`).
- `accepted_values` on `fct_channel_performance.channels`, to catch silently broken classification if the macro's output values ever change.
