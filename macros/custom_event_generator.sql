{% macro custom_event_generator(event_name) %}
    select * from events where event_name = {{event_name}}
{% endmacro %}