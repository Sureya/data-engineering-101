CREATE TABLE IF NOT EXISTS daily_weather(
	sunset TIMESTAMP NOT NULL,
	sunrise TIMESTAMP NOT NULL,
	humidity INTEGER,
	max_temperature DOUBLE PRECISION NOT NULL,
	min_temperature DOUBLE PRECISION NOT NULL,
	status VARCHAR(35),
	raw JSON,
	extract_date TIMESTAMP NOT NULL constraint daily_weather_pk primary key
)