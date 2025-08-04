// src/components/ViewASubscription.jsx
import React from 'react';
import './ViewASubscription.css';
import '../pages/ViewAllUsers.css';

const ViewASubscription = ({ user, onClose }) => {
  if (!user) return null;

  return (
    <div className="modal-overlay">
      <div className="subscription-modal">
        <h3 className="modal-username">charlieAngel</h3>
        <p className="modal-subtitle">Premium<br /><span className="modal-level">Lvl. 27</span></p>

        <div className="modal-section">
        <h4>Personal Details</h4> <hr />
        <div className="field-grid">
            <div className="field-label">First Name</div>
            <div className="field-value">Pittzza</div>

            <div className="field-label">Last Name</div>
            <div className="field-value">Bull</div>

            <div className="field-label">Username</div>
            <div className="field-value">@PitBulk101</div>

            <div className="field-label">Date of Birth</div>
            <div className="field-value">12 May 1998</div>

            <div className="field-label">Email</div>
            <div className="field-value">pitbulk@gmail.com</div>
        </div>
        </div>

        <div className="modal-section">
        <h4>Account Details</h4> <hr />
        <div className="field-grid">
            <div className="field-label">Level</div>
            <div className="field-value">Intermediate</div>

            <div className="field-label">Account</div>
            <div className="field-value">Premium</div>
        </div>
        </div>

        <div className="modal-section">
        <h4>Current Subscription</h4> <hr />
        <div className="field-grid">
            <div className="field-label">Plan</div>
            <div className="field-value">Monthly Plan</div>

            <div className="field-label">Price</div>
            <div className="field-value">$2.99 / Month</div>

            <div className="field-label">Renewal Date</div>
            <div className="field-value">August 20, 2025</div>
        </div>
        </div>

        <div className="modal-section">
          <h4>Payment Details</h4> <hr/>
          <p>
            <img src="/visa.png" alt="Visa" className="visa-icon" />
            Visa **** 1234
          </p>
        </div>

        <div className="modal-section">
          <h4>Transaction History</h4>
          <hr/>
          <div className="transaction-row">
            <span>July 20, 2025</span>
            <span className="paid-tag">Paid</span>
            <span className="card-text">Visa **** 1234</span>
          </div>
          <div className="transaction-row">
            <span>June 20, 2025</span>
            <span className="paid-tag">Paid</span>
            <span className="card-text">Visa **** 1234</span>
          </div>
        </div>

        <button className="ok-button" onClick={onClose}>OK</button>
      </div>
    </div>
  );
};

export default ViewASubscription;
