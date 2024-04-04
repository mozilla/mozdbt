-- https://docs.getdbt.com/docs/collaborate/govern/model-versions#how-is-this-different-from-just-creating-a-new-model
{% macro create_latest_version_view() %}
    -- this hook will run only if the model is versioned, and only if it's the latest version
    -- otherwise, it's a no-op
    {% if model.get('version') and model.get('version') == model.get('latest_version') and config.get('publish_view') %}
        -- publish view in non-derived dataset
        {% set new_relation = this.incorporate(path={"identifier": model['name'], "schema": model["schema"].replace("_derived", "")}) %}

        {% set existing_relation = load_relation(new_relation) %}

        {% if existing_relation and not existing_relation.is_view %}
            {{ drop_relation_if_exists(existing_relation) }}
        {% endif %}
        
        {% set create_view_sql -%}
            -- this syntax may vary by data platform
            CREATE OR REPLACE VIEW {{ new_relation }}
            AS SELECT * FROM {{ this }}
        {%- endset %}
        
        {% do log("Creating view " ~ new_relation ~ " pointing to " ~ this, info = true) if execute %}
        
        {{ return(create_view_sql) }}
        
    {% else %}
        -- no-op
        select 1 as id
    {% endif %}
{% endmacro %}
