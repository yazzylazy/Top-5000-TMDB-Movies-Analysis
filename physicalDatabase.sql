CREATE DATABASE databasename;

-- movie dimension
CREATE TABLE movie (
    title varchar(255) NOT NULL,
    genre varchar(255),
	orginal_language varchar(255),
	spoken_language varchar(255),
	runtime int NOT NULL,
    PRIMARY KEY (...)
);
