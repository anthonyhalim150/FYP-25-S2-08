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
  },
];

const ViewAllFeedbacks = () => {
  const [filter, setFilter] = useState('All');
  const [showConfirm, setShowConfirm] = useState(null);
  const [modalFeedback, setModalFeedback] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [currentTab, setCurrentTab] = useState()
  const [selectedTab, setSelectedTab] = useState('All');

const filteredFeedbacks = dummyFeedbacks.filter((fb) => {
  const isSearchMatch =
    fb.user.toLowerCase().includes(searchTerm.toLowerCase()) ||
    fb.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
    fb.message.toLowerCase().includes(searchTerm.toLowerCase());

  const isStatusMatch =
    selectedTab === 'All' || fb.status.toLowerCase() === selectedTab.toLowerCase();

  return isSearchMatch && isStatusMatch;
});


  return (
    <PageLayout>
    <div className="all-users-container">
      <div className="user-content">
      <div className= "user-header">
        <h2>All Feedbacks</h2>
        <div className="header-row">
          <div className="user-tabs-container">
            {['All', 'Pending', 'Accepted', 'Rejected'].map((tab) => (
              <div
                key={tab}
                className={`user-tab ${selectedTab === tab ? 'active' : ''}`}
                onClick={() => setSelectedTab(tab)}
              >
                {tab}
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
              <td>{fb.user}</td>
              <td>{fb.email}</td>
              <td>{new Date(fb.submittedAt).toLocaleDateString('en-GB', { day: '2-digit', month: 'short',  year: 'numeric' }).replace(/ (\d{4})$/,  ', $1')}</td>
              <td>
                <span className={`status-badge ${fb.status.toLowerCase()}`}>
                  {fb.status}
                </span>
               {/* className={`badge ${fb.status.toLowerCase()}`}>{fb.status}</td> */}
              </td>
              <td>
                {fb.status === 'Pending' ? (
                  <>
                    <button className="accept-btn" onClick={(e) => { e.stopPropagation(); setShowConfirm({ id: fb.id, action: 'publish' }); }}>Publish</button>
                    <button className="reject-btn" onClick={(e) => { e.stopPropagation(); setShowConfirm({ id: fb.id, action: 'reject' }); }}>Reject</button>
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
          <div className="confirm-modal" onClick={(e) => e.stopPropagation()} style={{ background: 'white', padding: '2rem', borderRadius: '16px', textAlign: 'center' }}>
            <p style={{ fontSize: '1.1rem', marginBottom: '1.5rem' }}>
              Are you sure you want to {showConfirm.action === 'publish' ? 'publish' : 'reject'}?
            </p>
            <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem' }}>
              <button className="cancel-btn" onClick={() => setShowConfirm(null)}>Cancel</button>
              <button className="confirm-btn" onClick={() => setShowConfirm(null)}>Confirm</button>
            </div>
          </div>
        </div>
      )}

      {/* Feedback Detail Modal */}
      {modalFeedback && (
        <div className="modal-overlay" onClick={() => setModalFeedback(null)}>
          <div className="feedback-detail-modal" style={{ background: 'white', borderRadius: '16px', padding: '2rem', maxWidth: '720px', margin: '0 auto', boxShadow: '0 10px 30px rgba(0,0,0,0.2)' }} onClick={(e) => e.stopPropagation()}>
            <button className="modal-close" onClick={() => setModalFeedback(null)} style={{ float: 'right' }}>✕</button>
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginBottom: '1.5rem' }}>
              <img src={modalFeedback.avatar} alt="Avatar" style={{ width: 60, height: 60, borderRadius: '50%' }} />
              <div>
                <h3 style={{ margin: 0 }}>@{modalFeedback.user}</h3>
                <p style={{ color: '#888', fontSize: '0.9rem', margin: 0 }}>{modalFeedback.accountType}</p>
              </div>
              <div style={{ marginLeft: 'auto', textAlign: 'right' }}>
                <p style={{ color: modalFeedback.status === 'Rejected' ? 'red' : 'green', fontWeight: 'bold', margin: 0 }}>{modalFeedback.status}</p>
                <p style={{ fontStyle: 'italic', fontWeight: 'bold', fontSize: '0.9rem', margin: 0 }}>
                  {new Date(modalFeedback.submittedAt).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).replace(/ (\d{4})$/, ',$1')}
                </p>
              </div>
            </div>
            <p style={{ fontSize: '1rem', lineHeight: '1.7', color: '#333' }}>{modalFeedback.message}</p>
          </div>
        </div>
      )}
      </div>
    </div>
    </PageLayout>
  );
};

export default ViewAllFeedbacks;
