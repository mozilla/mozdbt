{% macro apply_metadata() %}

  ALTER TABLE {{ this }} 
  SET OPTIONS (
    description = "{{ model.get('description', '') }}" || "\n\nhttps://github.com/mozilla/mozdbt/blob/main/models/" || "{{ model.path }}"
  )

  {% do log("Apply metadata to" ~ this, info = true) if execute %}
{% endmacro %}
