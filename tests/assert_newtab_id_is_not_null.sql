SELECT
   *
FROM
    {{ ref('newtab_visits') }}
WHERE
    newtab_visit_id IS NULL
    AND submission_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 DAY)