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
  const [dark, setdark] =useState(false);
  const [weather, setweather] =useState("")

  const handleSearch = async (name) =>{
    const fullname= encodeURIComponent(name);
    try{

      await fetch(`/update/${fullname}/`, 
      {method: 'PUT'}); //elsőként az update elágazást tölti be mert 
      // így ha már rendelkezik a tároló az adattal akkor egyszerűen frissíti
      //  és nem lesz kulcsütközési hiba
      
      const jsonResponse= await fetch(`/json/${fullname}/`,
      {method: 'GET'}); // majd json elágazással bekérem
      const datas=await jsonResponse.json(); //elmentem json formátumba

      const Data={
        key: JSON.parse(datas.key), // itt külön szedem az adatokat a 
        // modells.py-ban megadott táblázatok mentén
        current_weather: JSON.parse(datas.current_weather),
        hourly_weather: JSON.parse(datas.hourly_weather),
        daily_weather: JSON.parse(datas.daily_weather),
      };

      setweather(Data);
      console.log(Data); //tesztcélból kiiratom az adatokat


    }catch (putError){

      console.error("Update cannot be completed, coming to get first this name", putError); // itt hibát dob nincsen még az adataink között jön a get elágazás


          try{

            await fetch(`/get/${fullname}/`,
            {method: 'GET'});

            const jsonResponse= await fetch(`/json/${fullname}/`,
            {method: 'GET'});
            const datas=await jsonResponse.json();

            const Data={
              key: JSON.parse(datas.key),
              current_weather: JSON.parse(datas.current_weather),
              hourly_weather: JSON.parse(datas.hourly_weather),
              daily_weather: JSON.parse(datas.daily_weather),
            };

            setweather(Data);
            console.log(Data);
          
      } catch (allError){
      console.error("There is no any name like that", allError); // Nincs ilyen városnév 
      // a nyilvántartásban
      alert("Error fetching weather")// Gui felületére is kiiratom, hogy ez sikertelen volt
      }
    }
  };
  return (// itt a háttér világos és sötét megoldását váltogató kapcsoló 
  // működését implementálom, illetve ha a setweather visszaad értékeket 
  // akkor kiíroatom a megfelelő oszlopba, ha nem akkor üresen marad
    <div className="app" dark-theme={dark ? "dark": "light"}> 
          <div className='main'>
            
            <Header 
            Search={handleSearch}
            Checked={dark}
            Change={()=> setdark(!dark)} 
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
