// components/TopBar.jsx
import React, {useState} from 'react';
import '../styles/Styles.css';
import './TopBar.css';

const TopBar = ({ searchTerm, onSearch }) => {

    const [SearchTerm, setSearchTerm] = useState('');
    
  return (
    <div className="top-bar">
      <img src="white-logo.png" alt="FitQuest Logo" className="topbar-logo" />
       {/* <div className="search-bar-container-topbar" style={{ maxWidth: '400px' }}>
          <input
            type="text"
            placeholder="Search all on FitQuest ..."
            className="search-bar"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="search-icon-btn">
            <img src="/icon-search.png" alt="Search" />
          </button>
        </div> */}
    </div>
  );
};

export default TopBar;
