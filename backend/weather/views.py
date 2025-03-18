from rest_framework.response import Response
from rest_framework.views import APIView
from django.core import serializers
from .services import *
from django.http import JsonResponse
from .models import *



class WeatherApiGet(APIView):


    def get(self, request, name):
    
        try:

            api=getApi(name)
            WeatherGet(name, api)
            
            return Response(
                {"message": f"A {name} is saved"}, status=201
                
            )
        except Exception as e:
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
        
            return Response(
                {"message": f"A {name} is updated"}, status=200
                
            )
        except Exception as e:
            return Response(
                {"message": f"Error occured update, {str(e)} "}, status=400
            )
                            
class WeatherApiJson(APIView):
    
    def get(self, request, name):
        
        try:
            
            key=WeatherKey.objects.get(name=name)
            key2=WeatherKey.objects.filter(name=name)
            weather=WeatherDetails.objects.filter(key=key)
            weather2=WeatherDetails2.objects.filter(key=key)
            weather3=WeatherDetails3.objects.filter(key=key)
            
            
            datas={
                "key":serializers.serialize('json', key2),
                "current_weather":serializers.serialize('json', weather),
                "hourly_weather": serializers.serialize('json', weather2),
                "daily_weather":serializers.serialize('json', weather3)
            }
            
            return JsonResponse(datas, content_type='application/json')
            
        except key.DoesNotExist:
            return JsonResponse(
                {"message": f"{name} is not found"}, status=404
            )
        
        except Exception as e:
             return JsonResponse(
                {"message": str(e)}, status=400
            )
            


