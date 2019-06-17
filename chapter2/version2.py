# in-built
import time
import logging
import argparse
from datetime import datetime

# 3rd party
import pyowm
import psycopg2


class FetchWeatherDetails(object):
    def __init__(self, connection_args, api_key, location):
        self.location = location
        self.api_key = api_key
        self.connection_parameters = connection_args
        self.db_connection = psycopg2.connect(**self.connection_parameters)
        self.cursor = self.db_connection.cursor()
        self.ddl_file = "ddl.sql"

        self.ensure_ddl()

    def __del__(self):
        self.cursor.close()
        self.db_connection.close()


    def ensure_ddl(self):
        _sql = open(self.ddl_file, "r").read()
        try:
            self.cursor.execute(_sql)
            self.db_connection.commit()
        except Exception as e:
            logging.error(e)

    def persist_single_row(self, record):
        """
            Takes in record to be inserted and updates the database with new
            records.
        :param sql_connection_parameters: dictionary with all connection parameters
        :param record: dictionary with one row of data
        :return:
        """

        _sql = 'INSERT INTO daily_weather (extract_date, sunset, sunrise, humidity, '\
              'max_temperature, min_temperature, status, raw) VALUES (%s, %s, %s, %s, %s, %s, ' \
              '%s, %s)'
        try:
            self.cursor.execute(_sql, (record["extract_date"], record["sunset"], record["sunrise"],
                                      record["humidity"], record["max_temperature"],
                                      record["min_temperature"], record["status"], record["raw"]))

            self.db_connection.commit()
        except Exception as e:
            logging.error(e)


    def fetch_weather_data(self):
        """
            Taken in OMW api key and returns weather data for the execution day.
        :return: dictionary with multiple weather data attributes.
        """
        logging.debug(f"API key received {self.api_key}")
        weather = pyowm.OWM(self.api_key)
        observation = weather.weather_at_place(self.location)
        response = observation.get_weather()

        logging.debug(f"API response {response}")

        return {
            "extract_date": datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S'),
            "sunset": time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(response.get_sunset_time())),
            "sunrise": time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(response.get_sunrise_time())),
            "humidity": response.get_humidity(),
            "max_temperature": response.get_temperature('celsius')["temp_max"],
            "min_temperature": response.get_temperature('celsius')["temp_min"],
            "status": response.get_detailed_status(),
            "raw": response.to_JSON()
        }


if __name__ == '__main__':
    FORMAT = '%(asctime)s,%(msecs)d %(levelname)-8s [%(lineno)d] %(message)s'
    logging.basicConfig(format=FORMAT, datefmt='%d-%m-%Y:%H:%M:%S', level=logging.INFO)

    parser = argparse.ArgumentParser()

    parser.add_argument("--location", required=False, type=str, default="London, GB",
                        help="location to fetch weather details from")

    parser.add_argument("--connect_timeout", required=False, type=int, default=3,
                        help="how many seconds to wait for database connection")

    parser.add_argument("--api_key", required=True, type=str, help="API key for OWM account")
    parser.add_argument("--database", required=True, type=str, help="Database name")
    parser.add_argument("--user", required=True, type=str, help="user name with")
    parser.add_argument("--password", required=True, type=str, help="password for the user")
    parser.add_argument("--host", type=str, default="localhost:5432", help="DB hostname")
    args = parser.parse_args()

    connection_parameters = {
        'database': args.database,
        'user': args.user,
        'password': args.password,
        'host': args.host,
        'connect_timeout': 3
    }

    record = FetchWeatherDetails(connection_args=connection_parameters, api_key=args.api_key,
                                  location=args.location)

    result_record = record.fetch_weather_data()
    logging.info(f"Extracted weather information for {result_record['extract_date']}")
    record.persist_single_row(result_record)
    logging.info(f"Database updated with details for {result_record['extract_date']}")
    logging.debug(result_record)
    logging.debug("Process completed")
