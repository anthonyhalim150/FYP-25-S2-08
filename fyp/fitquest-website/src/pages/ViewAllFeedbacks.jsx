import React, { useState } from 'react';
import './ViewAllFeedbacks.css';
import PageLayout from '../components/PageLayout';

const dummyFeedbacks = [
  {
    id: 'f001',
    user: 'Matilda Swayne',
    email: 'matilda@gmail.com',
    submittedAt: '2025-06-20',
    status: 'Pending',
    message: 'The log button sometimes doesn’t respond. Please check.',
    avatar: '/icon-avatar2.png',
    accountType: 'Premium',
    rating: 2.5,
  },
  {
    id: 'f002',
    user: 'Jacob Tan',
    email: 'jacob@gmail.com',
    submittedAt: '2025-07-01',
    status: 'Accepted',
    message: 'FitQuest is very useful and I enjoy using it every day!',
    avatar: '/icon-avatar1.png',
    accountType: 'Free',
    rating: 5,
  },
  {
    id: 'f003',
    user: 'Alisa Yuen',
    email: 'alisa@gmail.com',
    submittedAt: '2025-06-30',
    status: 'Rejected',
    message: 'There is a bug with my level not updating properly.',
    avatar: '/icon-avatar3.png',
    accountType: 'Premium',
    rating: 3.5,
  },
];

const renderStars = (rating) => {
  return [...Array(5)].map((_, i) => {
    const diff = rating - i;
    let cls = 'empty';
    if (diff >= 1) cls = '';
    else if (diff >= 0.5) cls = 'half';
    const char = cls === 'half' ? '⯨' : '★';
    return <span key={i} className={`star ${cls}`}>{char}</span>;
  });
};

const ViewAllFeedbacks = () => {
  const [showConfirm, setShowConfirm] = useState(null);
  const [modalFeedback, setModalFeedback] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTab, setSelectedTab] = useState('All');

  const filteredFeedbacks = dummyFeedbacks.filter((fb) => {
    const matchesSearch =
      fb.user.toLowerCase().includes(searchTerm.toLowerCase()) ||
      fb.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      fb.message.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesTab =
      selectedTab === 'All' || fb.status.toLowerCase() === selectedTab.toLowerCase();
    return matchesSearch && matchesTab;
  });

  const statusCounts = {
    All: dummyFeedbacks.length,
    Pending: dummyFeedbacks.filter(fb => fb.status === 'Pending').length,
    Accepted: dummyFeedbacks.filter(fb => fb.status === 'Accepted').length,
    Rejected: dummyFeedbacks.filter(fb => fb.status === 'Rejected').length,
  };

  return (
    <PageLayout>
      <div className="all-users-container">
        <div className="user-content">
          <div className="user-header">
            <h2>All Feedbacks</h2>
            <div className="header-row">
              <div className="user-tabs-container">
                {['All', 'Pending', 'Accepted', 'Rejected'].map((tab) => (
                  <div
                    key={tab}
                    className={`user-tab ${selectedTab === tab ? 'active' : ''}`}
                    onClick={() => setSelectedTab(tab)}
                  >
                    {tab} <span className="tab-count">({statusCounts[tab]})</span>
                  </div>
                ))}
              </div>
              <div className="search-bar-container">
                <input
                  type="text"
                  placeholder="Search feedback by email or words ..."
                  className="search-bar"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
                <button className="search-icon-btn">
                  <img src="/icon-search.png" alt="Search" />
                </button>
              </div>
            </div>
          </div>

          <table className="users-table">
            <thead>
              <tr>
                <th>Username</th>
                <th>Email</th>
                <th>Submitted Date</th>
                <th>Status</th>
                <th>Manage</th>
              </tr>
            </thead>
            <tbody>
              {filteredFeedbacks.map((fb) => (
                <tr key={fb.id} onClick={() => setModalFeedback(fb)}>
                  <td>
                    <div className="feedback-user-cell">
                      <span>{fb.user}</span>
                      <div className="star-rating">{renderStars(fb.rating || 0)}</div>
                    </div>
                  </td>
                  <td>{fb.email}</td>
                  <td>{new Date(fb.submittedAt).toLocaleDateString('en-GB', {
                    day: '2-digit', month: 'short', year: 'numeric'
                  }).replace(/ (\d{4})$/, ', $1')}</td>
                  <td>
                    <span className={`status-badge ${
                        fb.status === 'Accepted' ? 'active' :
                        fb.status === 'Rejected' ? 'suspended' : 'pending'}`}>
                        {fb.status}
                    </span>
                  </td>
                  <td>
                    {fb.status === 'Pending' ? (
                      <>
                        <button className="suspend-btn" onClick={(e) => { e.stopPropagation(); setShowConfirm({ id: fb.id, action: 'reject' }); }}>Reject</button>
                        <button className="confirm-btn" onClick={(e) => { e.stopPropagation(); setShowConfirm({ id: fb.id, action: 'publish' }); }}>Publish</button>
                      </>
                    ) : (
                      <button className="view-btn" onClick={(e) => { e.stopPropagation(); setModalFeedback(fb); }}>View</button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {/* Confirmation Modal */}
          {showConfirm && (
            <div className="modal-overlay" onClick={() => setShowConfirm(null)}>
              <div className="confirm-modal" onClick={(e) => e.stopPropagation()}>
                <p>Are you sure you want to {showConfirm.action === 'publish' ? 'publish' : 'reject'}?</p>
                <div className="modal-buttons">
                  <button className="cancel-btn" onClick={() => setShowConfirm(null)}>Cancel</button>
                  <button
                    className={
                      showConfirm.action === 'publish' ? 'confirm-btn' : 'suspend-btn'
                    }
                    onClick={() => setShowConfirm(null)}
                  >
                    Confirm
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* Feedback Detail Modal */}
          {modalFeedback && (
            <div className="modal-overlay" onClick={() => setModalFeedback(null)}>
              <div className="feedback-detail-modal" onClick={(e) => e.stopPropagation()}>
                <button className="modal-close" onClick={() => setModalFeedback(null)}>✕</button>
                <div className="feedback-header">
                  <img src={modalFeedback.avatar} alt="Avatar" className="feedback-avatar" />
                  <div className="feedback-user-info">
                    <h3>@{modalFeedback.user}</h3>
                    <p className="account-type">{modalFeedback.accountType}</p>
                  </div>
                  <div className="feedback-status-date">
                    <p className={`feedback-status ${modalFeedback.status.toLowerCase()}`}>{modalFeedback.status}</p>
                    <p className="submitted-date">
                      {new Date(modalFeedback.submittedAt).toLocaleDateString('en-GB', {
                        day: '2-digit', month: 'long', year: 'numeric'
                      })}
                    </p>
                  </div>
                </div>

                <div className="feedback-rating-row">
                  <span className="rating-value">{modalFeedback.rating?.toFixed(1)}</span>
                  <div className="star-rating">{renderStars(modalFeedback.rating || 0)}</div>
                </div>

                <div className="feedback-tags">
                  <button className="feedback-tag">UI/UX</button>
                  <button className="feedback-tag">AI Integrated Support</button>
                </div>

                <p className="feedback-message">{modalFeedback.message}</p>

                <div className="modal-back-btn-container">
                  <button className="modal-back-btn" onClick={() => setModalFeedback(null)}>Back</button>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </PageLayout>
  );
};

export default ViewAllFeedbacks;
