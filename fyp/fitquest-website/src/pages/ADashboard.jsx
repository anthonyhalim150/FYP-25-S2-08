import React, { useEffect, useRef, useState } from 'react';
import { Routes, Route, useNavigate } from 'react-router-dom';
import './ADashboard.css';

import PageLayout from '../components/PageLayout.jsx';

import AllUsersPage from './ViewAllUsers';
import AllTournamentsPage from './ViewAllTournaments';
import AllFeedbacksPage from './ViewAllFeedbacks';

const ADashboard = () => {
  const manageSectionRef = useRef(null);
  const [isVisible, setIsVisible] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const observer = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) setIsVisible(true);
    }, { threshold: 0.1 });

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
    { icon: "/icon-tournament.png", label: "All Tournaments", color: "gradient-red", path: "/All-Tournaments" },
    { icon: "/icon-feedback.png", label: "All Feedbacks", color: "gradient-pink", path: "/All-Feedbacks" }
  ];

  return (
    <PageLayout>
    <section className="hero-section">
      <div className="hero-left-column">
        <h1 className="pixel-font">From Goals to Glory,</h1>
        <h2 className="pixel-font">One Quest at a Time.</h2>
        <div className="search-bar-container">
          <input className="search-bar" type="text" placeholder="Search everything on FitQuest" />
          <button className="search-icon-btn">
            <img src="/icon-search.png" alt="Search" />
          </button>
        </div>
        <img src="/icon-trophy.png" alt="Trophy" className="hero-trophy" />
      </div>

      <div className="hero-feature-column">
        <div className="hero-feature-card" onClick={() => navigate("/All-Users")}>
          <img src="/icon-totalUsers.png" alt="All Users" />
          <span>All Users</span>
        </div>
        <div className="hero-feature-card" onClick={() => navigate("/All-Feedbacks")}>
          <img src="/icon-feedback.png" alt="All Feedbacks" />
          <span>All Feedbacks</span>
        </div>
        <div className="hero-feature-card" onClick={() => navigate("/All-Tournaments")}>
          <img src="/icon-tournament.png" alt="All Tournaments" />
          <span>All Tournaments</span>
        </div>
      </div>
    </section>



        <div className="dashboard-content">
        {/* Full-width Navy Background Section */}
        <div className="stat-section-wrapper">
          <h2 className="stat-section-title">Your Step, Your Journey</h2>
          <section className="stat-overview-section">
            <div className="mini-stat-card">
              <img src="/icon-totalUsers.png" alt="Users" />
              <div>
                <h3>300</h3>
                <p>Total Users</p>
              </div>
            </div>
            <div className="mini-stat-card">
              <img src="/icon-activeUsers.png" alt="Active Users" />
              <div>
                <h3>126</h3>
                <p>Active Users</p>
              </div>
            </div>
            <div className="mini-stat-card">
              <img src="/icon-premium.png" alt="Premium Users" />
              <div>
                <h3>9</h3>
                <p>Premium Users</p>
              </div>
            </div>
          </section>
        </div>
        </div>
    </PageLayout>
  );
};

export default function AdminRoutes() {
  return (
    <Routes>
      <Route path="/" element={<ADashboard />} />
      <Route path="/All-Users" element={<AllUsersPage />} />
      <Route path="/All-Tournaments" element={<AllTournamentsPage />} />
      <Route path="/All-Feedbacks" element={<AllFeedbacksPage />} />
    </Routes>
  );
}
