# in-built
import time
import logging
import argparse

# 3rd party
import pyowm


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
    args = parser.parse_args()

    result_record = fetch_weather_data(args.api_key)

    logging.debug(result_record)
    logging.info("Process completed")


