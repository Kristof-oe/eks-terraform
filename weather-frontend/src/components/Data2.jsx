import React from "react";
import './Data2.css'
import { DateTime } from 'luxon';

const Data2 = ({daily}) => {

  const Time = (l) => {
    return DateTime.fromISO(l, { zone: 'utc' }).toFormat('DD');
    // ez szükséges volt ahhoz, hogy emberi szemnek normális időt adjon ki, 
    // és ne másodpercre pontosan adja meg
  }; 
  return (

    <div className='weather-data'>

       {daily.map((day, index) => (
          <div key={index}>

            <h4>{Time(day.fields.dt)}</h4>
            <h4>{day.fields.temp}°C</h4>
            <img src={`http://openweathermap.org/img/wn/${day.fields.icon}@2x.png`} 
                
                alt={day.fields.description}/>
            <p>{day.fields.pressure} hPa</p>
            <p>{day.fields.clouds} %</p>
            <p>{day.fields.wind_speed} metre/sec</p>
            <p>{day.fields.wind_deg} °</p>
            <p>{day.fields.humidity} %</p>
            <p>{day.fields.dew_point} °C</p>
            

            </div>
      ))} 
    </div>
  )
}

export default Data2