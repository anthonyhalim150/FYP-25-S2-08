import React, { useState } from 'react';
import '../styles/Styles.css'; // Add feedback styles here or extend your existing CSS

const dummyFeedbacks = [
  {
    id: 'f001',
    user: 'Matilda Swayne',
    email: 'matilda@gmail.com',
    submittedAt: '2024-06-15',
    status: 'Pending',
    type: 'Bug Report',
    message: 'The log button sometimes doesn’t respond.',
  },
  {
    id: 'f002',
    user: 'Jacob Tan',
    email: 'jacob@gmail.com',
    submittedAt: '2024-06-14',
    status: 'Accepted',
    type: 'Suggestion',
    message: 'Add a night mode toggle to the dashboard.',
  },
  {
    id: 'f003',
    user: 'Alisa Yuen',
    email: 'alisa@gmail.com',
    submittedAt: '2024-06-13',
    status: 'Rejected',
    type: 'Bug Report',
    message: 'Images don’t load properly when offline.',
  },
];

const ViewAllFeedbacks = () => {
  const [filter, setFilter] = useState('All');

  const filteredFeedbacks =
    filter === 'All' ? dummyFeedbacks : dummyFeedbacks.filter(f => f.status === filter);

  return (
    <div className="all-users-container">
      <header>
        <img src="/white-logo.png" alt="Logo" className="logo" />
        <nav><a href="/dashboard">Dashboard</a></nav>
      </header>

      <div className="page-title-with-search">
        <h2>All Feedbacks</h2>
        <select onChange={(e) => setFilter(e.target.value)} value={filter}>
          <option value="All">All</option>
          <option value="Pending">Inbox</option>
          <option value="Accepted">Accepted</option>
          <option value="Rejected">Rejected</option>
        </select>
      </div>

      <table className="users-table">
        <thead>
          <tr>
            <th>From</th>
            <th>Email</th>
            <th>Submitted</th>
            <th>Type</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {filteredFeedbacks.map(fb => (
            <tr key={fb.id} onClick={() => console.log("View details for:", fb.id)}>
              <td>{fb.user}</td>
              <td>{fb.email}</td>
              <td>{fb.submittedAt}</td>
              <td>{fb.type}</td>
              <td>
                <span className={`badge ${fb.status.toLowerCase()}`}>
                  {fb.status}
                </span>
              </td>
              <td>
                {fb.status === 'Pending' && (
                  <>
                    <button className="accept-btn">Accept</button>
                    <button className="reject-btn">Reject</button>
                  </>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ViewAllFeedbacks;
