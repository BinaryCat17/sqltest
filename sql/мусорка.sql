CREATE VIEW fight_pairs (name1, name2, firstpoints, sumpoints) AS with control as (
    SELECT
        DISTINCT ON (name1) *
    FROM
        (
            SELECT
                p1.name AS name1,
                p2.name AS name2,
                p1.points AS firstpoints,
                p1.points + p2.points AS sumpoints
            FROM
                splitted_persons p1,
                splitted_persons p2
            WHERE
                p1.case
                    = 'first'
                    AND p2.case
                        = 'second'
                        ORDER BY
                            random()
                    ) t
                )
            select
                DISTINCT ON (control.name2) *
            FROM
                control;

