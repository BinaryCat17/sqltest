CREATE TABLE pool (
    pool_id serial NOT NULL,
    name varchar(32) NOT NULL,
    class varchar(32) NOT NULL,
    spec varchar(32) NOT NULL,
    skill varchar(32) NOT NULL,
    attr varchar(32) NOT NULL,
    equip varchar(32) NOT NULL,
    PRIMARY KEY (pool_id)
);

\copy pool (name, class, spec, skill, attr, equip) FROM 'data/shiza.csv' DELIMITER ';' CSV;