import React from "react";
import { NavLink } from "react-router-dom";
import "../styles/components/Navigation.css";

const Navigation = () => {
  return (
    <nav className="bottom-nav">
      <NavLink to="/challenges">❗</NavLink>
      <NavLink to="/friends">👥</NavLink>

      {/* Centered Home Button */}
      <div className="home-button-container">
        <NavLink to="/" className="home-button">🏠</NavLink>
      </div>

      <NavLink to="/events">📅</NavLink>
      <NavLink to="/leaderboard">🏆</NavLink>
    </nav>
  );
};

export default Navigation;
