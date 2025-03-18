import React from 'react'
import './Weather.css'

const WeatherW = ({current, name}) => {
  

  return (

      <div className='Weather'>
         
        <h1>Idő</h1>
        <h2>Neve</h2>
        <p>°C</p>

        <p>Kép</p>
        <div className='Table'>
        <tr>
          <td>
          Nyomás 
          </td>
          <td className='Table2'>
          hPa
          </td>
        </tr>
        <tr>
          <td>
          Felhők 
          </td>
          <td className='Table2'>
          %
          </td>
        </tr>
        <tr>
          <td>
          láthatóság
          </td>
          <td className='Table2'>
          km
          </td>
        </tr>
        <tr>
          <td>
          Szél fújása
          </td>
          <td className='Table2'>
          metre/sec
          </td>
        </tr>
        <tr>
          <td>
          Szél iránya
          </td>
          <td className='Table2'>
           °
          </td>
        </tr>
        <tr>
          <td>
          Páratartalom
          </td>
          <td className='Table2'>
           %
          </td>
        </tr>
        <tr>
          <td>
          Napkelte
          </td>
          <td className='Table2'>
          Idő
          </td>
        </tr>
        <tr>
          <td>
          Napnyugta
          </td>
          <td className='Table2'>
          Idő
          </td>
        </tr>
        </div>
       
       
      </div>
  );
};

export default WeatherW
