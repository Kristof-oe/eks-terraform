from rest_framework import serializers
from .models import WeatherKey, WeatherDetails, WeatherDetails2, WeatherDetails3

class WeatherKeySerializer(serializers.ModelSerializer):
    class Meta:
        model = WeatherKey
        fields = '__all__'

class WeatherDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = WeatherDetails
        fields = '__all__'

class WeatherDetails2Serializer(serializers.ModelSerializer):
    class Meta:
        model = WeatherDetails2
        fields = '__all__'

class WeatherDetails3Serializer(serializers.ModelSerializer):
    class Meta:
        model = WeatherDetails3
        fields = '__all__'