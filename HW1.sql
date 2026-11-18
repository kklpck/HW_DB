/*
Хамзин Ильнар Рамильевич
Вариант 16

Описание предметной области
Описание репертуаров кинотеатров. 
Включает в себя кинотеатры, фильмы, людей, участвующих в фильмах, расписание кинотеатров. 
Кинотеатры описываются названием и адресом. 
Фильмы состоят из: названия, жанра, продолжительности, страны или стран происхождения, 
кинокомпании, задействованных актёров с указанием ролей и других участников съёмок с указанием выполняемых задач, 
минимального допустимого возраста. 
Люди, участвующие в фильмах, характеризуются: фамилией, именем, датой рождения, множеством фильмов, 
в которых принимали участие, с указанием выполняемых задач (например, режиссёр) или ролей. 
Расписание кинотеатров состоит из указания зала, даты и времени начала, указания фильма, стоимостей билетов в зависимости от зон.
Один и тот же человек мог решать различные задачи и играть несколько ролей в одном и том же фильме.
*/

DROP TABLE IF EXISTS ticket_price CASCADE;
DROP TABLE IF EXISTS movie_tasks CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS movie_country CASCADE;
DROP TABLE IF EXISTS seance CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS movie CASCADE;
DROP TABLE IF EXISTS task CASCADE;
DROP TABLE IF EXISTS company CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS area CASCADE;
DROP TABLE IF EXISTS hall CASCADE;
DROP TABLE IF EXISTS cinema CASCADE;

CREATE TABLE cinema(
	cinema_id serial PRIMARY KEY,
	cinema_name varchar(50) NOT NULL,
	cinema_address varchar(200) NOT NULL
);

CREATE TABLE hall(
	hall_id serial PRIMARY KEY,
	cinema_id integer NOT NULL REFERENCES cinema(cinema_id),
	hall_name varchar(50) NOT NULL
);

CREATE TABLE area(
	area_id serial PRIMARY KEY,
	hall_id integer NOT NULL REFERENCES hall(hall_id),
	area_name varchar(50) NOT NULL
);

CREATE TABLE genre(
	genre_id serial PRIMARY KEY,
	genre_name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE country(
	country_id serial PRIMARY KEY,
	country_name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE company(
	company_id serial PRIMARY KEY,
	company_name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE task(
	task_id serial PRIMARY KEY,
	task_name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE movie(
	movie_id serial PRIMARY KEY,
	movie_name varchar(200) NOT NULL,
	movie_duration integer NOT NULL CHECK (movie_duration > 0),
	minimal_age integer NOT NULL CHECK (minimal_age >= 0),
	genre_id integer NOT NULL REFERENCES genre(genre_id),
	company_id integer NOT NULL REFERENCES company(company_id)
);

CREATE TABLE person(
	person_id serial PRIMARY KEY,
	person_surname varchar(50) NOT NULL,
	person_name varchar(50) NOT NULL,
	birthday date NOT NULL
);

CREATE TABLE seance(
	seance_id serial PRIMARY KEY,
	hall_id integer NOT NULL REFERENCES hall(hall_id),
	movie_id integer NOT NULL REFERENCES movie(movie_id),
	start_time timestamp NOT NULL
);

CREATE TABLE movie_country(
	movie_id integer NOT NULL REFERENCES movie(movie_id),
	country_id integer NOT NULL REFERENCES country(country_id),

	PRIMARY KEY(movie_id, country_id)
);

CREATE TABLE roles(
	movie_id integer NOT NULL REFERENCES movie(movie_id),
	person_id integer NOT NULL REFERENCES person(person_id),
	role_name varchar(200) NOT NULL,

	PRIMARY KEY(movie_id, person_id, role_name)
);

CREATE TABLE movie_tasks(
	movie_id integer NOT NULL REFERENCES movie(movie_id),
	person_id integer NOT NULL REFERENCES person(person_id),
	task_id integer NOT NULL REFERENCES task(task_id),

	PRIMARY KEY(movie_id, person_id, task_id)
);

CREATE TABLE ticket_price(
	seance_id integer NOT NULL REFERENCES seance(seance_id),
	area_id integer NOT NULL REFERENCES area(area_id),
	price numeric(8,2) NOT NULL CHECK (price > 0),

	PRIMARY KEY(seance_id, area_id)
);