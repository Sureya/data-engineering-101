---
title: Python
layout: template
filename: chapter1
--- 
# Chapter - 2

# Tech Stack
*   Programming language: [Python3.6](https://www.tutorialspoint.com/python3/)
*   Source Code Management: [Git](https://product.hubspot.com/blog/git-and-github-tutorial-for-beginners)
*   SQL - [PostgreSQL 11.2](http://www.postgresqltutorial.com/)
*   IDE - [Pycharm](https://www.jetbrains.com/help/pycharm/installation-guide.html?section=macOS) + [DataGrip](https://www.jetbrains.com/help/datagrip/install-and-set-up-product.html?keymap=secondary_mac_os_x_10.5_) 

Reference Links



*   [Python - 1](https://www.learnpython.org/)
*   [Python - 2](https://codingbat.com/python)
*   [Psql - Mac](https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb)


# Project - 1

Let’s imagine you work in a company where your company needs to collect basic weather data for London every day starting today. 
You are the engineer assigned to do this work, you think about the problem statement and you note that the requirement is not detailed, 
A requirement should always be precise and scoped, so you ask your manager for following details so that you can start working on it.  
 

Details required to start coding
*   Is there any specific data source that the company would like to or Can I use any data source?
*   What kind of weather data do you need to collect exactly?
*   How many times should the application run each day?
*   Where should the results be stored?


You get a response from the business saying, they mandatorily need following attributes,
*    Temperature in Celsius, 
*    Sunrise time, 
*    Sunset time, 
*    Clear description
*    And any other attributes that might be of substance 


## Step 1 Basic Python Application (v0)

After doing some basic googling you find Open Weather Map (OMW) API that has all the data that you need. 


### API details

*   The home page can be found [here](https://openweathermap.org/)
*   API limits can be found [here](https://openweathermap.org/price)
*   The API documentation can be found [here](https://openweathermap.org/current)  
*   Python library for the API can be found [here](https://github.com/csparpa/pyowm) 

Once you have all the details, your initial local code would look something like this

[fileLink](https://github.com/Sureya/data-engineering-101/blob/master/chapter2/version0.py)

```python
import pyowm
import time
import json

API_KEY = "<YOUR_API_KEY>"
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
```


If you execute the code with your API key, you will see that it fetches all the desired attributes. 
Now that you have the core functionality of the code working, we need to clean up the code and make sure its production ready. 
Definition of “Production code” is subjective to each company and teams. But overall, a production-ready code should have a minimum of following standards

*   Logging on multiple levels
*   Multiprocessing /Threading, if needed    
*   Simple Execution Strategy
*   Sensible unit tests


## So if we are to refactor our code to meet the above standards it would look like the following,

[fileLink](https://github.com/Sureya/data-engineering-101/blob/master/chapter2/version1.py)


```python
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

```


We can see that we have changed quite a few things, mainly we have 
*   Removed all print statements
*   Made the application more modular
*   Gave all the inputs as command line arguments
*   Have different levels of logging

For this application use case, this would be an acceptable clean code to be considered as v1. 
But we still haven’t stored the data anywhere, hence the project is incomplete. 
In the next part, we will be dealing with V2 of our code which includes, database connectivity


## Step 2 Python application with persistent storage

	When we execute the script, we can see we successfully fetch all the data we need. But we haven’t stored the data anywhere yet, we will be using PSQL to persist our data, for local development this chapter assumes that you have PSQL installed in your local machine.

	To get started we need to design a simple relational table. Very broadly speaking, the process of deciding how many tables we need, how many what are the columns in each table, and type of data each column is going to hold, is called Data Modeling. For this example, to keep things simple we will be storing our data in a single table as follows,


SQL script to create this table would be as follows,

[fileLink](https://github.com/Sureya/data-engineering-101/blob/master/chapter2/ddl.sql)

```sql
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
```

This will be definition our relational table, in which the data extracted from our application will be stored.
Now that we have created a simple schema to store our data, we need to alter our python code to 
store the data into the table we created and that will be our v2 of the code.

[fileLink](https://github.com/Sureya/data-engineering-101/blob/master/chapter2/version2.py)
```python
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

```

Since our code was modular, all we had to do was add couple of methods to include database connectivity.
At this stage, it is safe to consider the project **done**, from an application development perspective.
If you are interested in learning how to deploy this application in cloud, please refer [here](https://github.com/Sureya/data-engineering-101/tree/master/chapter3) 

