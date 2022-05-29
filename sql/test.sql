select
    pool_id,
    name,
    class,
    spec,
    skill,
    attr,
    equip,
    relig,
    race,
    SUBSTRING(relat, 0, LENGTH(relat)) as relat,
    CASE
        WHEN relat LIKE '%+' THEN 1
        ELSE 0
    END AS relat_val
from
    pool;