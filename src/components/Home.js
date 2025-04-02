import React from "react";

const Home = () => {
  return (
    <div className="home-container">
      <header className="top-bar">
        <span className="profile-icon">👤</span>
        <h1>XP Game</h1>
        <span className="gcoins">G-Coins: 100</span>
      </header>

      <section className="events">
        <h2>Events</h2>
        <div className="event-list">
          <div className="event">Event 1</div>
          <div className="event">Event 2</div>
          <div className="event">Event 3</div>
        </div>
      </section>

      <section className="challenges">
        <h2>Available Challenges</h2>
        <ul>
          <li>Find 5 clues <span>3/5</span></li>
          <li>Solve Problem #491 <span>0/1</span></li>
          <li>Complete a mystery <span>2/3</span></li>
        </ul>
      </section>

      <section className="leaderboard">
        <h2>Top 100 XParts in Singapore</h2>
        <ol>
          <li>4789</li>
          <li>4632</li>
          <li>4580</li>
          <li>4597</li>
          <li>4501</li>
        </ol>
      </section>
    </div>
  );
};

export default Home;
