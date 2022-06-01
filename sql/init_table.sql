CREATE TABLE pool (
    pool_id serial NOT NULL,
    name varchar(32) NOT NULL,
    spec varchar(32) NOT NULL,
    skill varchar(32) NOT NULL,
    attr varchar(32) NOT NULL,
    equip varchar(32) NOT NULL,
    PRIMARY KEY (pool_id)
);

CREATE TABLE stats (
    name varchar(32) NOT NULL,
    type varchar(5) NOT NULL,
    epoh int,
    PRIMARY KEY(name, type),
    CHECK (type in ('spec', 'skill', 'attr', 'equip'))
);

CREATE TABLE persons (
    name varchar(32) NOT NULL,
    died int,
    points int NOT NULL,
    PRIMARY KEY(name),
    ON DELETE CASCADE,
    ON UPDATE CASCADE,
);

CREATE TABLE links (
    name1 varchar(32) NOT NULL,
    type1 varchar(5) NOT NULL,
    name2 varchar(32) NOT NULL,
    type2 varchar(5) NOT NULL,
    weight int NOT NULL,
    PRIMARY KEY (name1, type1, name2, type2),
    FOREIGN KEY(name1, type1) REFERENCES stats(name, type),
    FOREIGN KEY(name2, type2) REFERENCES stats(name, type)
);

CREATE TABLE person_links (
    personname varchar(32) NOT NULL,
    statname varchar(32) NOT NULL,
    stattype varchar(5) NOT NULL,
    PRIMARY KEY(personname, statname, stattype),
    FOREIGN KEY (personname) REFERENCES persons (name),
    FOREIGN KEY (statname, stattype) REFERENCES stats (name, type)
);
