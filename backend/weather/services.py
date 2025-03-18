import requests
from .models import *
from datetime import *

Api="https://api.openweathermap.org/data/3.0/onecall"
Geo="https://api.openweathermap.org/geo/1.0/direct"
Key="bc5b5f0927b2bf8b6ccfdd009c6e9a87"
limit=1

def getApi(name): #api kezelése
    
    details={
        
        "q":name,
        "limit":limit,
        "appid":Key
    }
    
    geo_r=requests.get(Geo, params=details) # api által adott adatokat kérjük
    if  geo_r.status_code==200: # ha minden jó akkor meg a eltároljuk a koordinátákat
        datas=geo_r.json()
        if datas:
            lat= datas[0]['lat'],
            lon= datas[0]['lon']
    elif  geo_r.status_code==404:
        raise Exception(f"{name} has not been found")
    elif  geo_r.status_code==500:
        raise Exception("Server problem")
    elif geo_r.status_code>=400:
        raise Exception(f"Request failed {name}")
        
    details2={
        
        'lat':lat,
        'lon':lon,
        'exclude':"minutely, alert",
        'appid':Key,
        'units':'metric'
    }
    
    weather_r=requests.get(Api, params=details2) #itt a második api által adott adatok
    weather_r.raise_for_status()
    
    return weather_r.json() 
    
class WeatherGet():
    def __init__(self, names, datas): #konsturktor használata
        
        self.name=names
        self.datas=datas
        self.Key=Key
        self.lat=self.datas['lat']
        self.lon=self.datas['lon']
        self.timezone_offset=self.datas['timezone_offset']
        self.weatherkey =self.weatherKey()
        self.weatherDetails1()
        self.weatherDetails2()
        self.weatherDetails3()
    
    def weatherKey(self): #kulcsmező létrejötte 
        
        return WeatherKey.objects.create(
            lat=self.lat,
            lon=self.lon,
            name=self.name,
            timezone_offset=self.timezone_offset
        )
        
    def weatherDetails1(self): #jelenlegi időjárás adat tárolása
        
        current=self.datas['current']
        
        current_weather=current['weather'][0]
    
        WeatherDetails.objects.create(
        
            key=self.weatherkey,
            dt=datetime.fromtimestamp(current['dt'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            sunrise=datetime.fromtimestamp(current['sunrise'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            sunset=datetime.fromtimestamp(current['sunset'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            temp=current['temp'],
            feels_like=current['feels_like'],
            pressure=current['pressure'],
            humidity=current['humidity'],
            dew_point=current['dew_point'],
            clouds=current['clouds'],
            visibility=current['visibility'],
            wind_speed=current['wind_speed'],
            wind_deg=current['wind_deg'],
            cid=current_weather['id'],
            main=current_weather['main'],
            description=current_weather['description'],
            icon=current_weather['icon']
    
    )
        
    def weatherDetails2(self): #óránkénti időjárás adat tárolása
        
        hourly=self.datas['hourly'][:7]
        weather=[]
        
        for hour in hourly:
            
            hourly_weather=hour['weather'][0]
            
            
            weather.append(
            
            WeatherDetails2(
            
            key=self.weatherkey,     
            dt=datetime.fromtimestamp(hour['dt'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            temp=hour['temp'],
            pressure=hour['pressure'],
            humidity=hour['humidity'],
            dew_point=hour['dew_point'],
            clouds=hour['clouds'],
            visibility=hour['visibility'],
            wind_speed=hour['wind_speed'],
            wind_deg=hour['wind_deg'],
            wind_gust=hour['wind_gust'],
            hid=hourly_weather['id'],
            main=hourly_weather['main'],
            description=hourly_weather['description'],
            icon=hourly_weather['icon']
                )
            )
            
        WeatherDetails2.objects.bulk_create(weather)
        
    def weatherDetails3(self): #napi időjárás adat tárolása
        
        daily=self.datas['daily'][:7]
        weather=[]
    
        for day in daily:
        
            daily_weather=day['weather'][0]
            weather.append(
                
            WeatherDetails3(
       
            key=self.weatherkey,
            dt=datetime.fromtimestamp(day['dt'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            sunrise=datetime.fromtimestamp(day['sunrise'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            sunset=datetime.fromtimestamp(day['sunset'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            moonrise=datetime.fromtimestamp(day['moonrise'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            moonset=datetime.fromtimestamp(day['moonset'], tz=timezone.utc) + timedelta(seconds=self.timezone_offset),
            temp=day['temp']['day'],
            temp_min=day['temp']['min'],
            temp_max=day['temp']['max'],
            feels_like_day=day['feels_like']['day'],
            feels_like_night=day['feels_like']['night'],
            pressure=day['pressure'],
            humidity=day['humidity'],
            dew_point=day['dew_point'],
            wind_speed=day['wind_speed'],
            wind_deg=day['wind_deg'],
            wind_gust=day['wind_gust'],
            clouds=day['clouds'],
            visibility=1,
            did=daily_weather['id'],
            main=daily_weather['main'],
            description=daily_weather['description'],
            icon=daily_weather['icon'],
                )
            )
        
        WeatherDetails3.objects.bulk_create(weather)
