#standardSQL

with source as (
  select
    id as post_id
    , * except(id)
  from {{ source('dummy', 'posts') }}
)

, final as (
  select
    -- ids
    post_id
    , user_id

    -- enums
    , status

    -- strings
    , title

    -- texts
    , content

    -- datetimes
    , created_at
    , updated_at
  from source
)

select
  *
from final
