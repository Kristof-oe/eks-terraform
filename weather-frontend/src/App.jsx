import React, { useState, useEffect } from 'react';
import Weather from './components/Weather';
import Header from './components/Header';
import Data from './components/Data';
import Data2 from './components/Data2';
import DataD from './components/DataD'
import Data2D from './components/Data2D'
import WeatherW from './components/WeatherW';
import './index.css';


const App = () => {
  const [isDark, setIsDark] =useState(false);
  const [weather, setweather] =useState("")

  const handleSearch = async (name) =>{
    const fullname= encodeURIComponent(name);
    try{

      await fetch(`http://frontend.weather.com/update/${fullname}/`, {method: 'PUT'});


      const jsonResponse= await fetch(`http://frontend.weather.com/json/${fullname}/`, {method: 'GET'});
      const datas=await jsonResponse.json();

      const Data={
        key: JSON.parse(datas.key),
        current_weather: JSON.parse(datas.current_weather),
        hourly_weather: JSON.parse(datas.hourly_weather),
        daily_weather: JSON.parse(datas.daily_weather),
      };

      setweather(Data);
      console.log(Data);


    }catch (upError){

      console.error("Update cannot be completed, coming to get first this name", upError);


          try{

            await fetch(`http://frontend.weather.com/get/${fullname}/`, {method: 'GET'});

        

            const jsonResponse= await fetch(`http://frontend.weather.com/json/${fullname}/`, {method: 'GET'});
            const datas=await jsonResponse.json();

            const Data={
              key: JSON.parse(datas.key),
              current_weather: JSON.parse(datas.current_weather),
              hourly_weather: JSON.parse(datas.hourly_weather),
              daily_weather: JSON.parse(datas.daily_weather),
            };

            setweather(Data);
            console.log(Data);
          
      } catch (ErrorAll){
      console.error("There is no any name like that", ErrorAll);
      alert("Error fetching weather")
      }
    }
  };
  return (
    <div className="app" dark-theme={isDark ? "dark": "light"}>

          <div className='main'>
            
            <Header 
            onSearch={handleSearch}
            IsChecked={isDark}
            handleChange={()=> setIsDark(!isDark)} 
            />
              { weather ? (
              <>
                      <Weather current={weather.current_weather} 
                      name={weather.key[0].fields.name}/>
                      <div className='second'>

                      <Data hourly={weather.hourly_weather}/>

                      <Data2 daily={weather.daily_weather}/>

                      </div>
              </>
            ) : (
                <>
                     <WeatherW/>
                      <div className='second'>

                      <DataD />

                      <Data2D />

                      </div>
                </>
            )} 
          </div>   
    </div>
    
      
  )
}

export default App
