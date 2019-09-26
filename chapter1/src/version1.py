# in-built
import time
import logging
import argparse
from datetime import datetime

# 3rd party
import pyowm


class FetchWeatherDetails(object):
    def __init__(self, api_key, location):
        self.location = location
        self.api_key = api_key

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

    parser.add_argument("--api_key", required=True, type=str, help="API key for OWM account")
    args = parser.parse_args()

    record = FetchWeatherDetails(api_key=args.api_key, location=args.location)

    result_record = record.fetch_weather_data()
    logging.info(f"Extracted weather information for {result_record['extract_date']}")
    logging.debug("Process completed")
