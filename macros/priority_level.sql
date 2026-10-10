{#- '3 - Moderate' / ' 3 - moderate ' -> 3 -#}
{% macro priority_level(column) -%}
  cast(substr(trim({{ column }}), 1, 1) as int)
{%- endmacro %}
