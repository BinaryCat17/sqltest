CREATE TABLE pool (
    pool_id serial NOT NULL,
    name varchar(32) NOT NULL,
    class varchar(32) NOT NULL,
    spec varchar(32) NOT NULL,
    skill varchar(32) NOT NULL,
    attr varchar(32) NOT NULL,
    equip varchar(32) NOT NULL,
    relig varchar(32) NOT NULL,
    race varchar(32) NOT NULL,
    relat varchar(32) NOT NULL,
    PRIMARY KEY (pool_id)
);

\copy pool (name, class, spec, skill, attr, equip, relig, race, relat) FROM 'data/shiza-attr.csv' DELIMITER ';' CSV;
delete from pool where name='name' 