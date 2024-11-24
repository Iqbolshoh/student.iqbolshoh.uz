SELECT
    u.id AS user_id,
    u.first_name,
    u.last_name,
    c.course_name,
    c.price AS course_price,
    CASE
        WHEN p.month_start_date = DATE_FORMAT(
            DATE_ADD(
                DATE_ADD(course_start_date, INTERVAL n MONTH),
                INTERVAL 1 MONTH
            ),
            '%Y-%m-%d'
        )
        AND p.month_end_date = DATE_FORMAT(
            DATE_ADD(
                DATE_ADD(course_start_date, INTERVAL n MONTH),
                INTERVAL 2 MONTH
            ),
            '%Y-%m-%d'
        ) THEN 'paid'
        ELSE 'unpaid'
    END AS status,
    t.first_name AS teacher_first_name,
    t.last_name AS teacher_last_name,
    DATE_FORMAT(
        DATE_ADD(
            DATE_ADD(course_start_date, INTERVAL n MONTH),
            INTERVAL 1 MONTH
        ),
        '%Y-%m-%d'
    ) AS month_start_date,
    DATE_FORMAT(
        DATE_ADD(
            DATE_ADD(course_start_date, INTERVAL n MONTH),
            INTERVAL 2 MONTH
        ),
        '%Y-%m-%d'
    ) AS month_end_date
FROM
    users u
    JOIN group_users gu ON gu.user_id = u.id
    JOIN course_groups cg ON cg.id = gu.group_id
    JOIN courses c ON c.id = cg.course_id
    LEFT JOIN users t ON t.id = cg.teacher_id
    LEFT JOIN payments p ON p.user_id = u.id
    AND p.course_id = c.id
    JOIN (
        SELECT
            -1 AS n
        UNION
        ALL
        SELECT
            0
        UNION
        ALL
        SELECT
            1
        UNION
        ALL
        SELECT
            2
        UNION
        ALL
        SELECT
            3
        UNION
        ALL
        SELECT
            4
        UNION
        ALL
        SELECT
            5
        UNION
        ALL
        SELECT
            6
    ) AS months
    JOIN (
        SELECT
            gu.user_id,
            cg.course_id,
            MIN(cg.created_at) AS course_start_date
        FROM
            group_users gu
            JOIN course_groups cg ON cg.id = gu.group_id
        GROUP BY
            gu.user_id,
            cg.course_id
    ) AS course_start_dates ON course_start_dates.user_id = u.id
    AND course_start_dates.course_id = c.id
WHERE
    DATE_ADD(course_start_date, INTERVAL n MONTH) <= CURRENT_DATE
GROUP BY
    u.id,
    u.first_name,
    u.last_name,
    c.course_name,
    c.price,
    course_start_dates.course_start_date,
    n,
    p.status,
    p.month_start_date,
    p.month_end_date,
    t.id,
    t.first_name,
    t.last_name
ORDER BY
    month_start_date ASC,
    c.course_name;