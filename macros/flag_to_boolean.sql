{#- Normalises mixed boolean encodings (true / TRUE / Y / 1 ...) to a real boolean; null stays null. -#}
{% macro flag_to_boolean(column) -%}
  case
    when {{ column }} is null then null
    when lower(trim(cast({{ column }} as {{ dbt.type_string() }}))) in ('true', 'y', 'yes', '1') then true
    when lower(trim(cast({{ column }} as {{ dbt.type_string() }}))) in ('false', 'n', 'no', '0') then false
    else null
  end
{%- endmacro %}
