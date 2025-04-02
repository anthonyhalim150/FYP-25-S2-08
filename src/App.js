import React from "react";
import Signup from "./components/Signup";
import Login from "./components/Login";
import { Routes, Route } from "react-router-dom";
import Home from "./components/Home";
import Events from "./components/Events";
import Challenges from "./components/Challenges";
import Leaderboard from "./components/Leaderboard";
import Navigation from "./components/Navigation";

function App() {
  return (
    <div className="app-container">
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/events" element={<Events />} />
        <Route path="/challenges" element={<Challenges />} />
        <Route path="/leaderboard" element={<Leaderboard />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/login" element={<Login />} />
      </Routes>

      <Navigation />
    </div>
  );
}

export default App;
