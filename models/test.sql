{{ config(materialized='view', schema='inlineschema') }}
select 1 as test