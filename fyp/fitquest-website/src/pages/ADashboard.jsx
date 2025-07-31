import React, { useEffect, useRef, useState } from 'react';
import { Routes, Route, useNavigate } from 'react-router-dom';
import './ADashboard.css';

import PageLayout from '../components/PageLayout.jsx';
import { fetchDashboardStats } from '../services/userService';

import AllUsersPage from './ViewAllUsers';
import AllTournamentsPage from './ViewAllTournaments';
import AllFeedbacksPage from './ViewAllFeedbacks';

const ADashboard = () => {
  const manageSectionRef = useRef(null);
  const [isVisible, setIsVisible] = useState(false);
  const navigate = useNavigate();

  const [stats, setStats] = useState({ total: 0, active: 0, premium: 0 });
  const [loading, setLoading] = useState(true);

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

  useEffect(() => {
    fetchDashboardStats()
      .then(data => setStats(data))
      .catch(() => setStats({ total: '-', active: '-', premium: '-' }))
      .finally(() => setLoading(false));
  }, []);

  // const renderStars = (rating) => {
  //   return [...Array(5)].map((_, i) => (
  //     <span
  //       key={i}
  //       style={{ color: i < rating ? '#ffc107' : '#ccc', fontSize: '1.2rem', marginRight: '2px' }}
  //     >
  //       ★
  //     </span>
  //   ));
  // };

  const renderStars = (rating) => {
  return [...Array(5)].map((_, i) => {
    const diff = rating - i;
    let starChar = '☆'; // default empty

    if (diff >= 1) {
      starChar = '★'; // full star
    } else if (diff >= 0.5) {
      starChar = '⯨'; // Unicode half-star lookalike OR use CSS/image
    }

    return (
      <span
        key={i}
        style={{
          color: starChar === '☆' ? '#ccc' : '#ffc107',
          fontSize: '1.2rem',
          marginRight: '2px',
        }}
      >
        {starChar}
      </span>
    );
  });
};



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
        <div className="hero-feature-card" onClick={() => navigate("/All-Tournaments")}>
            <img src="/icon-tournament.png" alt="All Tournaments" />
            <span>All Tournaments</span>
        </div>
        <div className="hero-feature-card" onClick={() => navigate("/All-Feedbacks")}>
          <img src="/icon-feedback.png" alt="All Feedbacks" />
          <span>All Feedbacks</span>
        </div>
        </div>
        
      </section>

      <div className="dashboard-content">
        <div className="stat-section-wrapper">
          <h2 className="stat-section-title">Your Step, Your Journey</h2>
          <section className="stat-overview-section">
            <div className="mini-stat-card">
              <img src="/icon-totalUsers.png" alt="Users" />
              <div>
                <h3>{loading ? '...' : stats.total}</h3>
                <p>Total Users</p>
              </div>
            </div>
            <div className="mini-stat-card">
              <img src="/icon-activeUsers.png" alt="Active Users" />
              <div>
                <h3>{loading ? '...' : stats.active}</h3>
                <p>Active Users</p>
              </div>
            </div>
            <div className="mini-stat-card">
              <img src="/icon-premium.png" alt="Premium Users" />
              <div>
                <h3>{loading ? '...' : stats.premium}</h3>
                <p>Premium Users</p>
              </div>
            </div>
          </section>
        </div>
      </div>

      {/* Customer Feedback Section */}
<div className="customer-feedback-section">
  <h2 className="feedback-title">Customers Feedback</h2>
  <div className="feedback-wrapper">
    {/* Left Score Box */}
    <div className="feedback-score-box">
      <div className="average-score">4.44</div>
        <div className="rating-bars">
          {[5, 4, 3, 2, 1].map((star, idx) => (
            <div className="rating-bar-row" key={star}>
              <div className="star-label">{star} Stars</div>
              <div className="bar-container">
                <div className="bar-fill" style={{ width: ['80%', '60%', '40%', '20%', '10%'][idx] }}></div>
              </div>
              <div className="bar-value">{[37, 10, 4, 1, 1][idx]}</div>
            </div>
          ))}
        </div>

      <div className="feedback-tags">
        <p><strong>What Customers Like</strong></p>
        <button className="feedback-tag">UI/UX</button>
        <button className="feedback-tag">All Integrated Support</button>
        <p style={{ marginTop: '1rem' }}><strong>FitQuest in Development</strong></p>
        <button className="feedback-tag warning">Slow Loading</button>
      </div>
    </div>

      {/* Right Recent Reviews */}
      <div className="feedback-reviews-box">
        <div className="reviews-header">
          <h3>Reviews (53)</h3>
          <button className="view-all-btn" onClick={() => navigate("/All-Feedbacks")}>
            View All Feedbacks
          </button>
        </div>
          <div className="review-scroll-container">
       <div className="review-entry">
    <p><strong>Anthony Halim (Lvl. 51)</strong><br />{renderStars(4)}</p>
    <p>This app really helped me stay consistent with my workouts. The daily reminders and progress tracking keep me on track!</p>
    <span className="review-date">3 days ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Felicia Lee (Lvl. 23)</strong><br />{renderStars(4.5)}</p>
    <p>I love the UI design and how seamless everything feels. It's fun to use and motivates me!</p>
    <span className="review-date">5 days ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Mohammed Zaki (Lvl. 12)</strong><br />{renderStars(3)}</p>
    <p>Good overall, but sometimes the reward wheel doesn't spin. Hope it gets fixed soon.</p>
    <span className="review-date">1 week ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Christy Tan (Lvl. 19)</strong><br />{renderStars(5)}</p>
    <p>Amazing! I never thought I'd enjoy working out at home this much. The challenges keep me engaged and the design is super cute 💪</p>
    <span className="review-date">4 days ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Raymond Chua (Lvl. 8)</strong><br />{renderStars(2)}</p>
    <p>The concept is great but it's still buggy. Sometimes my progress doesn't save and the steps count doesn't update properly.</p>
    <span className="review-date">2 weeks ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Alisha Gomez (Lvl. 34)</strong><br />{renderStars(4)}</p>
    <p>I like the progress visualization and the point system, but would be nice if more workout plans were available for free users.</p>
    <span className="review-date">1 week ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Johnathan Wee (Lvl. 17)</strong><br />{renderStars(3.5)}</p>
    <p>Decent app with potential. I use it mostly for step tracking and reminders. Would appreciate more integration with fitness devices.</p>
    <span className="review-date">6 days ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Priya Ramesh (Lvl. 41)</strong><br />{renderStars(5)}</p>
    <p>Absolutely love it. The FitQuest team really knows how to motivate users. Daily quests, gamification, and clear UI — just perfect.</p>
    <span className="review-date">2 days ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Samuel Cheong (Lvl. 15)</strong><br />{renderStars(4)}</p>
    <p>This app really helps me stay on track, especially with the premium features. It’s like having a fitness coach in my pocket.</p>
    <span className="review-date">8 days ago</span>
  </div>

  <div className="review-entry">
    <p><strong>Andrea Neo (Lvl. 28)</strong><br />{renderStars(4.5)}</p>
    <p>I’ve been using FitQuest for 3 months now and my activity levels have improved significantly. I particularly enjoy the tournament feature — competing with others is so motivating. Highly recommend to anyone trying to stay fit at home!</p>
    <span className="review-date">Yesterday</span>
  </div>
  </div>
      </div>
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
