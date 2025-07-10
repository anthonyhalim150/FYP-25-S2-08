import React, { useState } from 'react';
import '../styles/Styles.css';
import './ViewAllUsers.css';
import PageLayout from '../components/PageLayout.jsx';
import ViewAUser from '../components/ViewAUser.jsx';

const ViewAllUsers = () => {
  const [selectedTab, setSelectedTab] = useState('All');
  const [selectedUser, setSelectedUser] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');


const dummyUsers = [
  {
    id: 1,
    username: 'jacob123',
    email: 'jacob123@gmail.com',
    role: 'Free',
    level: 'Lvl. 12',
    isSuspended: false,
    first_name: 'Jacob',
    last_name: 'Smith',
    dob: '1998-04-22',
    account: 'Basic Plan',
    preferences: {
      workout_frequency: '3 times/week',
      fitness_goal: 'Weight Loss',
      workout_time: 'Morning',
      fitness_level: 'Beginner',
      injury: 'None'
    }
  },
  {
    id: 2,
    username: 'matildaHealth',
    email: 'matildaH@gmail.com',
    role: 'Premium',
    level: 'Lvl. 23',
    isSuspended: false,
    first_name: 'Matilda',
    last_name: 'Grey',
    dob: '1995-11-10',
    account: 'Premium Plus',
    preferences: {
      workout_frequency: '5 times/week',
      fitness_goal: 'Build Muscle',
      workout_time: 'Evening',
      fitness_level: 'Intermediate',
      injury: 'Knee'
    }
  },
  {
    id: 3,
    username: 'pitbull101',
    email: 'pitbull101@gmail.com',
    role: 'Premium',
    level: 'Lvl. 41',
    isSuspended: true,
    first_name: 'Mike',
    last_name: 'Johnson',
    dob: '1989-02-05',
    account: 'Premium Plan',
    preferences: {
      workout_frequency: 'Daily',
      fitness_goal: 'Athletic Performance',
      workout_time: 'Afternoon',
      fitness_level: 'Advanced',
      injury: 'Shoulder'
    }
  },
  {
    id: 4,
    username: 'lucySky',
    email: 'lucySky@gmail.com',
    role: 'Free',
    level: 'Lvl. 8',
    isSuspended: false,
    first_name: 'Lucy',
    last_name: 'Williams',
    dob: '2001-07-30',
    account: 'Basic Plan',
    preferences: {
      workout_frequency: '2 times/week',
      fitness_goal: 'Stay Active',
      workout_time: 'Morning',
      fitness_level: 'Beginner',
      injury: 'None'
    }
  },
  {
    id: 5,
    username: 'davidFit',
    email: 'davidFit@gmail.com',
    role: 'Premium',
    level: 'Lvl. 19',
    isSuspended: false,
    first_name: 'David',
    last_name: 'Lee',
    dob: '1993-12-12',
    account: 'Premium Plan',
    preferences: {
      workout_frequency: '4 times/week',
      fitness_goal: 'Tone Body',
      workout_time: 'Evening',
      fitness_level: 'Intermediate',
      injury: 'Ankle'
    }
  },
  {
    id: 6,
    username: 'annaBoost',
    email: 'annaBoost@gmail.com',
    role: 'Premium',
    level: 'Lvl. 37',
    isSuspended: true,
    first_name: 'Anna',
    last_name: 'Brooks',
    dob: '1990-05-18',
    account: 'Premium Plus',
    preferences: {
      workout_frequency: 'Daily',
      fitness_goal: 'Endurance',
      workout_time: 'Night',
      fitness_level: 'Advanced',
      injury: 'None'
    }
  }
];


  const filteredUsers = dummyUsers.filter((user) => {
    if (selectedTab === 'Suspended' && !user.isSuspended) return false;
    if (selectedTab === 'Active' && user.isSuspended) return false;
    return user.username.toLowerCase().includes(searchTerm.toLowerCase());
  });

  return (
    <PageLayout>
    <div className="admin-container">
      <div className="user-content">
        <div className="user-header">
          <h2>All Users</h2>
          <div className="header-row">
            <div className="user-tabs-container">
              {['All', 'Active', 'Suspended'].map((tab) => (
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
              <th>Role</th>
              <th>Level</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filteredUsers.map((user) => (
              <tr key={user.id} onClick={() => setSelectedUser(user)} style ={{cursor: 'pointer'}}>
                <td>{user.username}</td>
                <td>{user.email}</td>
                <td>{user.role}</td>
                <td>{user.level}</td>
                <td>
                  <span className={`status-badge ${user.isSuspended ? 'suspended' : 'active'}`}>
                    {user.isSuspended ? 'Suspended' : 'Active'}
                  </span>
                </td>
                <td>
                  <button className="view-btn">View</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {selectedUser && (
          <ViewAUser user={selectedUser} onClose={() => setSelectedUser(null)} />
        )}

      </div>
    </div>

    </PageLayout>
  );
};

export default ViewAllUsers;