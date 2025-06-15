import React, {useEffect, useRef, useState} from 'react';
import "../styles/Styles.css";

const ADashboard = () => {

    const manageSectionRef = useRef(null);
    const [isVisible, setIsVisible] = useState(false);

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

  return (
    <div style={{ fontFamily: 'sans-serif', backgroundColor: '#fff' }}>
      <header>
        <img src="/white-logo.png" alt="FitQuest Logo" className='logo'/>
        <nav>
          <a href="#" style={{ color: '#fff', marginRight: '1rem', textDecoration: 'none' }}>Users</a>
          <a href="#" style={{ color: '#fff', marginRight: '1rem', textDecoration: 'none' }}>Challenge</a>
          <a href="#" style={{ color: '#fff', textDecoration: 'none' }}>Tournament</a>
        </nav>
      </header>

        <section className="hero-section">
        <div className="hero-left">
            <h1 className="pixel-font">From Goals to Glory,<br />One Quest at a Time.</h1>
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


      {/* <section className='manage-card-section'>
        <div style={{ display: 'flex', justifyContent: 'center', marginTop: '2rem', gap: '2rem' }}>
            <div className='manage-card-wrapper'>
                <img className='manage-icon' src="/icon-challenge.png" alt="Challenge" />
                <div className='manage-card'>
                    <p>All Challenges</p>     
                </div>
            </div>

            <div className='manage-card-wrapper'>
                <img className='manage-icon' src="/icon-tournament.png" alt="Tournament" />
                <div className='manage-card'>
                    <p>All Tournaments</p>     
                </div>
            </div>

            <div className='manage-card-wrapper'>
                <img className='manage-icon' src="/icon-workout.png" alt="Workout" />
                <div className='manage-card'>
                    <p>All Workouts</p>     
                </div>
            </div>
        </div>
      </section> */}

      <section className="manage-section" ref={manageSectionRef}>
        <div className={`manage-card-container ${isVisible ? 'slide-up' : ''}`}>
            <div className="manage-card-wrapper">
            <img className="manage-icon" src="/icon-challenge.png" alt="Challenge" />
            <div className="manage-card">
                <p>All Challenges</p>
            </div>
            </div>

            <div className="manage-card-wrapper">
            <img className="manage-icon" src="/icon-tournament.png" alt="Tournament" />
            <div className="manage-card">
                <p>All Tournaments</p>
            </div>
            </div>

            <div className="manage-card-wrapper">
            <img className="manage-icon" src="/icon-workout.png" alt="Workout" />
            <div className="manage-card">
                <p>All Workouts</p>
            </div>
            </div>
        </div>
    </section>

    </div>
  );
};

export default ADashboard; 
