import React, { useState } from 'react';
import './Header.css'
import search_icon from '../assets/search.png'

const Header = ({ onSearch, handleChange, IsChecked }) => {
    const [query, setQuery] = useState(null);
  
    const handleSearch = () => {
      onSearch(query);
      setQuery('');
    };
  return (
    <div className="Header">

       <div class="form-check form-switch">
          <input 
          class="form-check-input"
          type="checkbox" 
          id="flexSwitchCheckChecked" 
          onClick={handleChange}
          checked={IsChecked}
          /> 
        </div>

        <div className='search-bar'>
            <input type='text' placeholder='Search'
              value={query} onChange={(e) => setQuery(e.target.value)}>
            </input>
              <img src={search_icon} alt="" onClick={handleSearch}/>
        </div>

    </div>
  );
};

export default Header;
