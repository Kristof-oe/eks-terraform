import React from "react"
import './Data.css'
import { DateTime } from 'luxon';

const Data = ({hourly}) => {

  const Time = (l) => {
    return DateTime.fromISO(l, { zone: 'utc' }).toFormat('HH:mm');
  }; 
  return (

    <div className='weather-data'>

      {hourly.map((hour, index) => (
          <div key={index}>
            
            <h4>{Time(hour.fields.dt)}</h4>
            <h4>{hour.fields.temp}°C</h4>
            <img src={`http://openweathermap.org/img/wn/${hour.fields.icon}@2x.png`} 
                
                alt={hour.description}/>
            <p>{hour.fields.pressure} hPa</p>
            <p>{hour.fields.clouds}%</p>
            <p>{hour.fields.wind_speed} metre/sec</p>
            <p>{hour.fields.wind_deg}°</p>
            <p>{hour.fields.humidity} %</p>
            <p>{hour.fields.dew_point}°C</p>

            

          </div>
      ))}
    </div>
  )
}

export default Data
