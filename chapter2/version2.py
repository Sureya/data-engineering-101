# in-built
import time
import logging
import argparse

# 3rd party
import pyowm
import psycopg2


def persist_single_row(sql_connection_parameters, record):
    """
        Takes in connection parameter and record to be inserted and updates the database with new records.
    :param sql_connection_parameters: dictionary with all connection parameters
    :param record: dictionary with one row of data
    :return:
    """
    sql = 'INSERT INTO daily_weather (extract_date, sunset, sunrise, humidity, max_temperature, min_temperature, ' \
          'status) VALUES (%s, %s, %s, %s, %s, %s, %s)'
    try:
        db_connection = psycopg2.connect(**sql_connection_parameters)
        cursor = db_connection.cursor()
        cursor.execute(sql, (record["extract_date"], record["sunset"], record["sunrise"], record["humidity"],
                             record["max_temperature"], record["min_temperature"], record["status"],))

        db_connection.commit()
        cursor.close()
        db_connection.close()
    except Exception as e:
        logging.error(e)


def fetch_weather_data(api_key):
    """
        Taken in OMW api key and returns weather data for the execution day.
    :param api_key: string api key
    :return: dictionary with multiple weather data attributes.
    """
    logging.debug(f"API key received {api_key}")
    weather = pyowm.OWM(api_key)
    observation = weather.weather_at_place('London,GB')
    response = observation.get_weather()

    logging.debug(f"API response {response}")

    return {
        "extract_date": time.strftime('%Y-%m-%d', time.gmtime(response.get_sunset_time())),
        "sunset": time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(response.get_sunset_time())),
        "sunrise": time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(response.get_sunrise_time())),
        "humidity": response.get_humidity(),
        "max_temperature": response.get_temperature('celsius')["temp_max"],
        "min_temperature": response.get_temperature('celsius')["temp_min"],
        "status": response.get_detailed_status()
    }


if __name__ == '__main__':
    FORMAT = '%(asctime)s,%(msecs)d %(levelname)-8s [%(lineno)d] %(message)s'
    logging.basicConfig(format=FORMAT, datefmt='%d-%m-%Y:%H:%M:%S', level=logging.INFO)

    parser = argparse.ArgumentParser()
    parser.add_argument("--api_key", required=True, type=str, help="API key for OWM account")
    parser.add_argument("--database", required=True, type=str, help="Database name to get connected to")
    parser.add_argument("--user", required=True, type=str, help="user name with appropriate privileges")
    parser.add_argument("--password", required=True, type=str, help="password for the username provided")
    parser.add_argument("--host", type=str,  default="localhost:5432", help="hostname where the database is hosted")
    args = parser.parse_args()

    connection_parameters = {
        'database': args.database,
        'user': args.user,
        'password': args.password,
        'host': args.host
    }

    result_record = fetch_weather_data(args.api_key)
    persist_single_row(sql_connection_parameters=connection_parameters, record=result_record)
    logging.debug(result_record)
    logging.info("Process completed")


