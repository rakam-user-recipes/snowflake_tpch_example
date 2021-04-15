{{
  config(
   
    schema = "RAKAM_AGGREGATES",
    alias = "SOURCE__TPCH__ORDERS__TOTALS_BY_DATE",
    materialized = "incremental"
  )
}}
SELECT * FROM (SELECT 
    CONVERT_TIMEZONE('UTC', source__tpch__orders.O_ORDERDATE) AS o_orderdate,
    count(*) AS total_orders,
    hll_accumulate(source__tpch__orders.O_CUSTKEY) AS total_users
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS AS source__tpch__orders


GROUP BY
    1 

) AS t
                            {% if is_incremental() %}
                               WHERE source__tpch__orders.O_ORDERDATE > (select max(o_orderdate) from {{ this }})
                            {% endif %}