import React from 'react'
import './Weather.css'
import { DateTime } from 'luxon';

const Weather = ({current, name}) => {
  

  const Time = (l) => {
    return DateTime.fromISO(l, { zone: 'utc' }).toFormat('HH:mm');
    // ez szükséges volt ahhoz, hogy emberi szemnek normális időt adjon ki, 
    // és ne másodpercre pontosan adja meg
  };

  return (

      <div className='Weather'>
         
        <h1>{Time(current[0].fields.dt)}</h1>
        <h2>{name}</h2>
        <p>{current[0].fields.temp} °C</p>

        <img src={`http://openweathermap.org/img/wn/${current[0].fields.icon}@2x.png`} 
                
                alt={current[0].fields.description}/>

        <div className='Table'>
        <tr>
          <td>
          Nyomás 
          </td>
          <td className='Table2'>
          {current[0].fields.pressure} hPa
          </td>
        </tr>
        <tr>
          <td>
          Felhők 
          </td>
          <td className='Table2'>
          {current[0].fields.clouds} %
          </td>
        </tr>
        <tr>
          <td>
          láthatóság
          </td>
          <td className='Table2'>
          {current[0].fields.visibility} km
          </td>
        </tr>
        <tr>
          <td>
          Szél fújása
          </td>
          <td className='Table2'>
          {current[0].fields.wind_speed} metre/sec
          </td>
        </tr>
        <tr>
          <td>
          Szél iránya
          </td>
          <td className='Table2'>
          {current[0].fields.wind_deg} °
          </td>
        </tr>
        <tr>
          <td>
          Páratartalom
          </td>
          <td className='Table2'>
          {current[0].fields.humidity} %
          </td>
        </tr>
        <tr>
          <td>
          Napkelte
          </td>
          <td className='Table2'>
          {Time(current[0].fields.sunrise)}
          </td>
        </tr>
        <tr>
          <td>
          Napnyugta
          </td>
          <td className='Table2'>
          {Time(current[0].fields.sunset)}
          </td>
        </tr>
        </div>
       
       
      </div>
  );
};

export default Weather
