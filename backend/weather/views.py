from rest_framework.response import Response
from rest_framework.views import APIView
from django.core import serializers
from .services import *
from django.http import JsonResponse
from .models import *
import logging

logger=logging.getLogger(__name__)

class WeatherApiHealth(APIView):
    
    def health(get, request):
         
        return Response(status=200)
        

class WeatherApiGet(APIView):


    def get(self, request, name):
    
        try:

            api=getApi(name)
            WeatherGet(name, api)
            
            logger.error(f"Weather data for {name} is getting successfully")

            return Response(
                {"message": f"A {name} is saved"}, status=201
                
            )
          
        except Exception as e:
             
            logger.error(f"Weather data for {name} is not gettting")

            return Response(
                {"message":f"Error occured {str(e)} "}, status=400
             
            )
           
            
class  WeatherApiUpdate(APIView):   
        
    def put(self, request, name):
        
        try:
            
            key=WeatherKey.objects.get(name=name)
            
            
            if key:
                key.delete()
            
            api=getApi(name)
            WeatherGet(name, api)
        

            logger.error(f"Weather data for {name} is updated successfully")

            return Response(
                {"message": f"A {name} is updated"}, status=200
                
            )
           
        except Exception as e:

            logger.error(f"Weather data for {name} is not updated")

            return Response(
                {"message": f"Error occured update, {str(e)} "}, status=400
            )
           
                            
class WeatherApiJson(APIView):
    
    def get(self, request, name):
        
        try:
            
            key=WeatherKey.objects.get(name=name)
            weather=WeatherDetails.objects.filter(key=key)
            weather2=WeatherDetails2.objects.filter(key=key)
            weather3=WeatherDetails3.objects.filter(key=key)
            
            
            datas={
                "key":serializers.serialize('json', [key]),
                "current_weather":serializers.serialize('json', weather),
                "hourly_weather": serializers.serialize('json', weather2),
                "daily_weather":serializers.serialize('json', weather3)
            }
            
            return JsonResponse(datas, content_type='application/json')
            
        except WeatherKey.DoesNotExist:

            logger.error(f"Weather data for {name} is not here")

            return JsonResponse(
                {"message": f"{name} is not found"}, status=404
            )
        
        except Exception as e:
            logger.error(f"Weather data for {name} is here")

            return JsonResponse(
                {"message": str(e)}, status=400
            )
            


