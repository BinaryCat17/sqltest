UPDATE
    links
SET
    weight = ceil(random() * 5);

UPDATE
    persons
SET
    died = (
        CASE
            WHEN (
                name IN (
                    SELECT
                        CASE
                            WHEN fc.outcome1 = 'win' THEN fc.name1
                            ELSE fc.name2
                        END
                    FROM
                        random_fight_conditions fc
                    WHERE
                        (
                            fc.name1 = name
                            AND fc.outcome1 = 'win'
                        )
                        OR (
                            fc.name2 = name
                            AND fc.outcome1 = 'died'
                        )
                )
            ) THEN 10
            ELSE 0
        END
    );

INSERT INTO
    persons (name, points)
SELECT
    pc.personname as name,
    sum(pc.weight) as points
FROM
    person_combos pc
GROUP BY
    pc.personname
ORDER BY
    pc.personname
ON CONFLICT (name) DO UPDATE SET points = EXCLUDED.points;