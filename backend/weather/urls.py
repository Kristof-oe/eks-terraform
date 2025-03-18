from django.urls import path
from .views import *

urlpatterns = [
     path('get/<str:name>/', WeatherApiGet.as_view(), name='weather-get'),
     path('update/<str:name>/', WeatherApiUpdate.as_view(), name='weather-put'),
     path('json/<str:name>/', WeatherApiJson.as_view(), name='wether-json'),
]
