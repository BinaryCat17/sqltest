CREATE MATERIALIZED VIEW splitted_persons AS with control as (
    select
        *
    from
        persons
    order by
        random()
    limit
        (
            select
                count(*) / 2
            from
                persons
        )
)
select
    *,
    case
        when t in (
            select
                t
            from
                control t
        ) then 'first'
        else 'second'
    end
from
    persons t;

CREATE VIEW persons_splitted_left as
select
    row_number() over (
        order by
            s.name
    ),
    s.name as name1,
    s.points as points1
from
    splitted_persons as s
WHERE
    s.case
        = 'first'
        ORDER BY
            random();

CREATE VIEW persons_splitted_right as
select
    row_number() over (
        order by
            s.name
    ),
    s.name as name2,
    s.points as points2
from
    splitted_persons as s
WHERE
    s.case
        = 'second'
        ORDER BY
            random();

CREATE MATERIALIZED VIEW fight_pairs as
SELECT
    l.name1,
    r.name2,
    l.points1 as firstpoints,
    l.points1 + r.points2 as sumpoints
FROM
    persons_splitted_left l,
    persons_splitted_right r
WHERE
    l.row_number = r.row_number;

CREATE VIEW random_fight_conditions (name1, name2, outcome1) AS
SELECT
    fp.name1,
    fp.name2,
    CASE
        WHEN ceil(random() * fp.sumpoints) <= fp.firstpoints THEN 'win'
        ELSE 'died'
    END
FROM
    fight_pairs fp;

CREATE VIEW swap_equip AS
SELECT
    CASE
        WHEN fc.outcome1 = 'win' THEN fc.name1
        ELSE fc.name2
    END as name,
    CASE
        WHEN fc.outcome1 = 'win' THEN pl2.statname
        ELSE pl1.statname
    END as statname
FROM
    random_fight_conditions fc,
    person_links pl1,
    person_links pl2
WHERE
    (
        fc.name1 = pl1.personname
        AND pl1.stattype = 'equip'
    )
    AND (
        fc.name2 = pl2.personname
        AND pl2.stattype = 'equip'
    )
order by
    fc.name1;

CREATE MATERIALIZED VIEW splitted_stats AS with control as (
    select
        *
    from
        stats
    order by
        random()
    limit
        (
            select
                count(*) / 2
            from
                stats
        )
)
select
    *,
    case
        when t in (
            select
                t
            from
                control t
        ) then 'first'
        else 'second'
    end
from
    stats t;

CREATE VIEW stats_splitted_left as
select
    s.name as name1,
    s.type as type1
from
    splitted_stats as s
WHERE
    s.case
        = 'first'
        ORDER BY
            random();

CREATE VIEW stats_splitted_right as
select
    s.name as name2,
    s.type as type2
from
    splitted_stats as s
WHERE
    s.case
        = 'second'
        ORDER BY
            random();

CREATE MATERIALIZED VIEW all_person_links AS
SELECT
    pl.personname,
    pl.statname,
    pl.stattype,
    CASE
        WHEN (
            l.name1 = pl.statname
            AND l.type1 = pl.stattype
        ) THEN l.name2
        ELSE l.name1
    END AS linkname,
    CASE
        WHEN (
            l.name1 = pl.statname
            AND l.type1 = pl.stattype
        ) THEN l.type2
        ELSE l.type1
    END AS linktype,
    l.weight
FROM
    person_links pl,
    links l
WHERE
    (
        l.name1 = pl.statname
        AND l.type1 = pl.stattype
    )
    OR (
        l.name2 = pl.statname
        AND l.type2 = pl.stattype
    )
ORDER BY
    statname;

CREATE VIEW person_combos AS with all_combos as (
    SELECT
        apll.*
    FROM
        all_person_links apll,
        all_person_links aplr
    WHERE
        apll.personname = aplr.personname
        AND apll.statname = aplr.linkname
        AND apll.stattype = aplr.linktype
        AND aplr.statname = apll.linkname
        AND aplr.stattype = apll.linktype
)
SELECT
    DISTINCT personname,
    weight,
    statname as name1,
    stattype as type1,
    linkname as name2,
    linktype as type2
FROM
    (
        SELECT
            personname,
            weight,
            CASE
                WHEN statname < linkname THEN statname
                ELSE linkname
            END AS statname,
            CASE
                WHEN statname < linkname THEN stattype
                ELSE linktype
            END AS stattype,
            CASE
                WHEN statname < linkname THEN linkname
                ELSE statname
            END AS linkname,
            CASE
                WHEN statname < linkname THEN linktype
                ELSE stattype
            END AS linktype
        FROM
            all_combos
    ) t