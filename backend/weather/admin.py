from django.contrib import admin
from .models import *

# # Register your models here.

class WeatherDetail(admin.ModelAdmin):
    list_display=("name", "lat", "lon", "timezone_offset")
    

class WeatherCurrent(admin.ModelAdmin):
     list_display=( "sunrise", "sunset","feels_like", "cid", 
                   "main", "description", 
                   "icon")
    
    
# class WeatherHourly(admin.ModelAdmin):
#     list_display=( "hourly_dt" , "hourly_temp","hourly_feels_like", "hourly_pressure", 
#                   "hourly_humidity", "hourly_dew_point", "hourly_clouds", "hourly_visibility",
#                   "hourly_wind_speed","hourly_wind_deg", "hourly_wind_gust", "hourly_id", 
#                   "hourly_main", "hourly_description", "hourly_icon")
    

# class WeatherDaily(admin.ModelAdmin):
#     list_display=( "daily_dt" , "daily_sunrise", "daily_sunset", "daily_moonrise", "daily_moonset", 
#                   "daily_temp_day", "daily_temp_min",  "daily_temp_max",  "daily_feels_like_day",
#                   "daily_feels_like_night","daily_pressure", "daily_humidity", "daily_dew_point", 
#                   "daily_wind_speed","daily_wind_deg", "daily_wind_gust", "daily_id", "daily_main", 
#                   "daily_description", "daily_icon")

admin.site.register(WeatherKey, WeatherDetail)
admin.site.register(WeatherDetails, WeatherCurrent)
# admin.site.register(WeatherDetails2, WeatherHourly)
# admin.site.register(WeatherDetails3, WeatherDaily)
