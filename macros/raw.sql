{#- Resolves a raw table: seeds locally / in CI, Lakehouse source in Fabric. -#}
{% macro raw(name) -%}
  {%- if var('use_seeds_as_sources') | as_bool -%}
    {{ ref('raw_' ~ name) }}
  {%- else -%}
    {{ source('lakehouse_raw', name) }}
  {%- endif -%}
{%- endmacro %}
