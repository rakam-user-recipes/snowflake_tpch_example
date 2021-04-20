{% for i in range(10) %}
   {{ config(materialized='ephemeral', name="random_events_"~i) }}
   select {{i}} as test
{% endfor %}
