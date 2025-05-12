import React, { useState } from 'react';
import './Header.css'
import search_icon from '../assets/search.png'

const Header = ({ Search, Change, Checked }) => {

    const [city, emptyCity] = useState("");

    const Searching = () => {
      Search(city);
      emptyCity('');
    };// későbbiekben szükséges mert ez tudja majd üríteni 
    // a search bart és tárolni a parentnek a város nevét

  return (
    <div className="Header">

       <div className="form-check form-switch">
          <input 
          className="form-check-input"
          type="checkbox" 
          id="flexSwitchCheckChecked" 
          // itt a gombbal a light és 
          // dark modot állítom be a képernyőn
          onClick={Change}
          checked={Checked}
          /> 
        </div>

        <div className='search'>
            <input type='text' placeholder='Search'
              value={city} onChange={(v) => emptyCity(v.target.value)}>
            </input>
             {/* itt a search bar helyezkedik ahol a gomb 
             lenyomásával kiüríti a search bart és halad tovább 
             a parenthez, hogy feldolgozza api kérésben*/}
            <button onClick={Searching} className='button-img'>
              <img src={search_icon}/>
            </button>
        </div>

    </div>
  );
};

export default Header;
