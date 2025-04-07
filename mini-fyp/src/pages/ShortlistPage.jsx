import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/components/ShortlistPage.css';

function ShortlistPage() {
  const [shortlist, setShortlist] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    // Simulate fetch from localStorage or backend
    const saved = JSON.parse(localStorage.getItem('shortlist')) || [
      { id: 1, name: 'Maria Lopez', specialty: 'Deep Clean' },
      { id: 2, name: 'James Tan', specialty: 'Weekly Cleaning' },
    ];
    setShortlist(saved);
  }, []);

  const removeFromShortlist = (id) => {
    const updated = shortlist.filter((c) => c.id !== id);
    setShortlist(updated);
    localStorage.setItem('shortlist', JSON.stringify(updated));
  };

  const viewProfile = (id) => {
    navigate(`/cleaner/${id}`);
  };

  return (
    <div style={{ padding: '2rem' }}>
      <h2>Your Shortlisted Cleaners</h2>

      {shortlist.length === 0 ? (
        <p>No cleaners in your shortlist yet.</p>
      ) : (
        <ul>
          {shortlist.map((cleaner) => (
            <li key={cleaner.id} style={{ marginBottom: '1rem' }}>
              <strong>{cleaner.name}</strong> — {cleaner.specialty}
              <button
                onClick={() => viewProfile(cleaner.id)}
                style={{ marginLeft: '1rem' }}
              >
                View
              </button>
              <button
                onClick={() => removeFromShortlist(cleaner.id)}
                style={{ marginLeft: '0.5rem', color: 'red' }}
              >
                Remove
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

export default ShortlistPage;
