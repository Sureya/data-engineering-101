import pyowm
import time
import json

API_KEY = "87d06047a03d842ac1e5ad1ea99a3355"
weather = pyowm.OWM(API_KEY)
observation = weather.weather_at_place('London,GB')
response = observation.get_weather()

data = {
    "sunset": time.strftime('%Y-%m-%d %H:%M:%S',  time.gmtime(response.get_sunset_time())),
    "sunrise": time.strftime('%Y-%m-%d %H:%M:%S',  time.gmtime(response.get_sunrise_time())),
    "humidity": response.get_humidity(),
    "max_temperature": response.get_temperature('celsius')["temp_max"],
    "min_temperature": response.get_temperature('celsius')["temp_min"],
    "status": response.get_detailed_status()
}


print(json.dumps(data, indent=6))
