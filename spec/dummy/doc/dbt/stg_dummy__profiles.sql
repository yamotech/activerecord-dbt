with

source as (

    select * from {{ source('dummy', 'profiles') }}

),

renamed as (

    select

          -- ids
          id as profile_id,
          user_id,

          -- strings
          first_name,
          last_name,

          -- datetimes
          created_at,
          updated_at

    from source

)

select * from renamed
