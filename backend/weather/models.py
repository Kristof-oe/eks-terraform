from django.db import models

class WeatherBase(models.Model): #ismétlődő adatok abstractba tétele
    
    dt=models.DateTimeField()
    temp=models.IntegerField()
    pressure=models.IntegerField()
    dew_point=models.FloatField()
    clouds=models.IntegerField()
    visibility=models.IntegerField()
    wind_speed=models.FloatField()
    wind_deg=models.IntegerField()
    humidity=models.IntegerField()
    
    class Meta:
        abstract=True
    

class WeatherKey(models.Model): #kulcs készítése
    
    lat=models.FloatField()
    lon=models.FloatField()
    name=models.CharField(max_length=200, blank=True)
    timezone_offset=models.FloatField()
    
class WeatherDetails(WeatherBase): #jelenlegi időjárási adatok
    
    key=models.ForeignKey(WeatherKey, on_delete=models.CASCADE, related_name='curentkey')
    sunrise=models.DateTimeField()
    sunset=models.DateTimeField()
    feels_like=models.FloatField()
    cid=models.IntegerField()
    main=models.CharField(max_length=30)
    description=models.CharField(max_length=30)
    icon=models.CharField(max_length=30)
    
class WeatherDetails2(WeatherBase): #óránkénit időjárási adatok
     
    key=models.ForeignKey(WeatherKey, on_delete=models.CASCADE, related_name='hourlykey')
    wind_gust=models.IntegerField()
    hid=models.IntegerField()
    main=models.CharField(max_length=30)
    description=models.CharField(max_length=30)
    icon=models.CharField(max_length=30)
    
class WeatherDetails3(WeatherBase): #napi időjárási adatok 
    
    key=models.ForeignKey(WeatherKey, on_delete=models.CASCADE, related_name='dailykey')
    sunrise=models.DateTimeField()
    sunset=models.DateTimeField()
    moonrise=models.DateTimeField()
    moonset=models.DateTimeField()
    temp_min=models.IntegerField()
    temp_max=models.IntegerField()
    feels_like_day=models.FloatField()
    feels_like_night=models.FloatField()
    wind_gust=models.IntegerField()
    did=models.IntegerField()
    main=models.CharField(max_length=30)
    description=models.CharField(max_length=30)
    icon=models.CharField(max_length=30)

    