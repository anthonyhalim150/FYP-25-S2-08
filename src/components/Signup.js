import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/components/Login.css"; // Reusing the login styles

const Signup = () => {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const navigate = useNavigate();

  const handleSignup = async (e) => {
    e.preventDefault();
    setError("");

    // Simulated signup logic (Replace with API call)
    if (username && email && password) {
      alert("Signup successful! Redirecting to login...");
      navigate("/login"); // Redirect to login page
    } else {
      setError("All fields are required!");
    }
  };

  return (
    <div className="login-container">
      <div className="login-card">
        <h2>Register</h2>
        {error && <p className="error-message">{error}</p>}
        <form onSubmit={handleSignup}>
          <div className="input-group">
            <label>Username</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          </div>
          <div className="input-group">
            <label>Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="input-group">
            <label>Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          <button type="submit" className="login-button">Register</button>
        </form>

        <p className="signup-link">
          Already logged in? <a href="/login">Login here</a>
        </p>
      </div>
    </div>
  );
};

export default Signup;
