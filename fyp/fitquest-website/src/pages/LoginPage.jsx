import { useState } from "react";
import Login from "../components/Login";
import googleLogo from "../assets/GoogleLogo.png";
import facebookLogo from "../assets/FacebookLogo.png";
import blackFitQuestLogo from "../assets/BlackLogo.png";
import backgroundImage from "../assets/LoginBackground.png";
import "../styles/Styles.css"; // Make sure to update this CSS file

const LoginPage = () => {
    const handleLoginSuccess = (email) => {
        console.log("User logged in as ", email);
        localStorage.setItem("mail:", email);
        window.location.href = "/dashboard";
    }
  return (
    <div className="fitquest-login-page" >
      <div className="fitquest-left-panel">
        <h1 className="pixel-font">From Goals to Glory,<br />One Quest at a Time.</h1>
      </div>

      <div className="fitquest-right-panel">
        <div className="fitquest-login-card">
          <img src={blackFitQuestLogo} alt="FitQuest Logo" className="fitquest-logo" />
          <h2>Log In</h2>
          <Login onLoginSuccess={handleLoginSuccess} />
        </div>
      </div>
    <img
      src={backgroundImage}
      alt="LogIn Page"
      className="fitquest-login-page-background"
    />
    </div>
  );
};

export default LoginPage;
