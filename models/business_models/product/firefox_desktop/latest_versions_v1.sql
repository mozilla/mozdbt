{{ 
   config(
        materialized='table',
        tags=["refresh_daily", "scheduled_in_airflow", "depends_on_glam__latest_versions"]
    )
}}

SELECT
    *
FROM
    moz-fx-data-shared-prod.telemetry_derived.latest_versions_v2
