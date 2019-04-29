CREATE SCHEMA IF NOT EXISTS weather;

CREATE TABLE IF NOT EXISTS weather.daily_weather
(
	sunset DATE NOT NULL,
	sunrise DATE NOT NULL,
	humidity INTEGER,
	max_temperature DOUBLE PRECISION NOT NULL,
	min_temperature DOUBLE PRECISION NOT NULL,
	status VARCHAR(35),
	extract_date DATE NOT NULL constraint daily_weather_pk primary key
);


