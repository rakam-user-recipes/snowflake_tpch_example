{{
  config(
   
    schema = "metriql_aggregates",
    database = "DEMO_DB",
    alias = "source_snowflake_tpch_sample_tpch_orders_segmentation_totals_by_date",
    materialized = "incremental",
    tags = ['metriql_materialize']
  )
}}
SELECT * FROM (SELECT 
    source_snowflake_tpch_sample_tpch_orders.O_ORDERDATE AS o_orderdate,
    source_snowflake_tpch_sample_tpch_orders.O_ORDERSTATUS AS o_orderstatus,
    source_snowflake_tpch_sample_tpch_orders.O_ORDERPRIORITY AS o_orderpriority,
    count(*) AS total_orders,
    hll_accumulate(source_snowflake_tpch_sample_tpch_orders.O_CUSTKEY) AS total_users
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS AS source_snowflake_tpch_sample_tpch_orders


GROUP BY
    1,  2,  3 

) AS source_snowflake_tpch_sample_tpch_orders
{% if is_incremental() %}
   WHERE source_snowflake_tpch_sample_tpch_orders.O_ORDERDATE > (select max(o_orderdate) from {{ this }})
{% endif %}