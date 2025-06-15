import React, {useEffect, useRef, useState} from 'react';
import {Routes, Route, Link, useNavigate } from 'react-router-dom';
import "../styles/Styles.css";

import AllUsersPage from './ViewAllUsers';
import AllChallengesPage from './ViewAllChallenges';
import AllTournamentsPage from './ViewAllTournaments';
import AllWorkoutsPage from './ViewAllWorkouts';
import AllAvatarsPage from './ViewAllAvatars';
import AllFeedbacksPage from './ViewAllFeedbacks';

const ADashboard = () => {

    const manageSectionRef = useRef(null);
    const [isVisible, setIsVisible] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        const observer = new IntersectionObserver(
            ([entry]) => {
                // console.log("🟡 Intersecting?", entry.isIntersecting);
                if (entry.isIntersecting) setIsVisible(true);
            },

            {threshold: 0.1}
        );

        if (manageSectionRef.current) {
            observer.observe(manageSectionRef.current);
        }

        return () => {
            if (manageSectionRef.current) {
                observer.unobserve(manageSectionRef.current);
            }
        };
    }, []);

     const cards = [
    { icon: "/icon-totalUsers.png", label: "All Users", color: "gradient-maroon", path: "/All-Users" },
    { icon: "/icon-challenge.png", label: "All Challenges", color: "gradient-yellow", path: "/All-Challenges" },
    { icon: "/icon-tournament.png", label: "All Tournaments", color: "gradient-red", path: "/All-Tournaments" },
    { icon: "/icon-workout.png", label: "All Workouts", color: "gradient-gray", path: "/All-Workouts" },
    { icon: "/icon-avatar.png", label: "All Avatars", color: "gradient-blue", path: "/All-Avatars" },
    { icon: "/icon-feedback.png", label: "All Feedbacks", color: "gradient-pink", path: "/All-Feedbacks" }
  ];

 return (
    <div style={{ fontFamily: 'sans-serif', backgroundColor: '#fff' }}>
      <header>
        <img src="/white-logo.png" alt="FitQuest Logo" className='logo'/>
        <nav>
          <Link to="/All-Users">Users</Link>
          <Link to="/All-Challenges">Challenge</Link>
          <Link to="/All-Tournaments">Tournament</Link>
        </nav>
      </header>

      <section className="hero-section">
        <div className="hero-left">
          <h1 className="pixel-font">From Goals to Glory,</h1>
          <h2 className="pixel-font">One Quest at a Time.</h2>
          <div className="search-bar-container">
            <input className="search-bar" type="text" placeholder="Search everything on FitQuest" />
            <button className="search-icon-btn">
              <img src="/icon-search.png" alt="Search" />
            </button>
          </div>
        </div>
        <img src="/icon-trophy.png" alt="Trophy" className="hero-trophy" />
      </section>

      <section className="stat-container">
        <h2>Your Space. Your Pace. Our Quest.</h2>
        <div className="stat-cards-container">
          <div className="stat-card">
            <img src="/icon-totalUsers.png" alt="Users" className="stat-icon" />
            <h3>300</h3>
            <p>Total Users</p>
          </div>
          <div className="stat-card">
            <img src="/icon-activeUsers.png" alt="Active Users" className="stat-icon" />
            <h3>126</h3>
            <p>Active Users</p>
          </div>
          <div className="stat-card">
            <img src="/icon-premium.png" alt="Premium Users" className="stat-icon" />
            <h3>9</h3>
            <p>Premium Users</p>
          </div>
        </div>
      </section>

      <section className="manage-section" ref={manageSectionRef}>
        <div className={`manage-card-container ${isVisible ? 'slide-up' : ''}`}>
          {cards.map((item, index) => (
            <div
              className="manage-card-wrapper"
              key={index}
              onClick={() => navigate(item.path)}
              style={{ cursor: 'pointer' }}
            >
              <img className="manage-icon" src={item.icon} alt={item.label} />
              <div className={`manage-card ${item.color}`}>
                <p>{item.label}</p>
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
};

export default function AdminRoutes() {
  return (
    <Routes>
      <Route path="/" element={<ADashboard />} />
      <Route path="/All-Users" element={<AllUsersPage />} />
      <Route path="/All-Challenges" element={<AllChallengesPage />} />
      <Route path="/All-Tournaments" element={<AllTournamentsPage />} />
      <Route path="/All-Workouts" element={<AllWorkoutsPage />} />
      <Route path="/All-Avatars" element={<AllAvatarsPage />} />
      <Route path="/All-Feedbacks" element={<AllFeedbacksPage />} />
    </Routes>
  );
}
