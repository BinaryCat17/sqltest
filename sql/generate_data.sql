insert into
    persons(name, points)
select
    name,
    0
from
    names
ORDER BY
    random()
LIMIT
    100;

insert into
    stats(type, name)
select
    'spec',
    spec
from
    pool;

insert into
    stats(type, name)
select
    'skill',
    skill
from
    pool;

insert into
    stats(type, name)
select
    distinct 'attr',
    attr
from
    pool;

insert into
    stats(type, name)
select
    distinct 'equip',
    equip
from
    pool;

UPDATE
    stats
SET
    epoh = ceil(random() * 5)
WHERE
    type ~ '(spec|equip)';

UPDATE
    persons
SET
    points = ceil(random() * 15);

INSERT INTO
    links(name1, type1, name2, type2, weight)
SELECT
    l.name1,
    l.type1,
    r.name2,
    r.type2,
    0
FROM
    stats_splitted_left l,
    stats_splitted_right r
WHERE
    l.name1 != r.name2
    AND l.type1 != r.type2
ORDER BY
    random()
LIMIT
    1000;

INSERT INTO
    person_links (personname, statname, stattype)
SELECT
    DISTINCT ON (p.name, s.type) p.name,
    s.name,
    s.type
FROM
    persons p,
    (
        SELECT
            *
        FROM
            stats
        ORDER BY
            random()
    ) s;

INSERT INTO
    persons (name, died, points)
SELECT
    'Clone' || se.name,
    NULL as died,
    0 as points
from
    swap_equip se;

INSERT INTO
    person_links (personname, statname, stattype)
SELECT
    'Clone' || p.name,
    CASE
        WHEN pl.stattype = 'equip' THEN p.statname
        ELSE pl.statname
    END,
    pl.stattype
FROM
    swap_equip p,
    person_links pl
WHERE
    pl.personname = p.name;

DELETE FROM
    persons
WHERE
    name in (
        SELECT
            CASE
                WHEN pc.points < p.points THEN pc.name
                ELSE p.name
            END
        FROM
            persons p,
            persons pc
        WHERE
            pc.name = ('Clone' || p.name)
    );

UPDATE
    TABLE persons
SET
    name = SUBSTR(name, 6)
WHERE
    name LIKE 'Clone%';