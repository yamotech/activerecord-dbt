#standardSQL

with source as (
  select
    id as profile_id
    , * except(id)
  from {{ source('dummy', 'profiles') }}
)

, final as (
  select
    -- ids
    profile_id
    , user_id

    -- strings
    , first_name
    , last_name

    -- datetimes
    , created_at
    , updated_at
  from source
)

select
  *
from final
