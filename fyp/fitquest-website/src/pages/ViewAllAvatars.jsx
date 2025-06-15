import React, { useState } from 'react';
import AvatarGrid from '../components/AvatarGrid';
import BackgroundGrid from '../components/BackgroundGrid';
import AvatarPreview from '../components/AvatarPreview';
import '../styles/Styles.css';

const ViewAllAvatars = () => {
  const [tab, setTab] = useState('avatar');
  const [selectedAvatar, setSelectedAvatar] = useState(null);
  const [selectedBackground, setSelectedBackground] = useState(null);

  return (
    <div className="all-workouts-container">
      <header>
        <img src="/white-logo.png" alt="Logo" className="logo" />
        <nav><a href="/dashboard">Dashboard</a></nav>
      </header>

      <div className="avatar-tabs">
        <button
          className={tab === 'avatar' ? 'active-tab' : ''}
          onClick={() => setTab('avatar')}
        >
          Avatar
        </button>
        <button
          className={tab === 'background' ? 'active-tab' : ''}
          onClick={() => setTab('background')}
        >
          Background
        </button>
      </div>

      <AvatarPreview
        avatar={selectedAvatar}
        background={selectedBackground}
      />

      {tab === 'avatar' ? (
        <AvatarGrid
          selectedAvatar={selectedAvatar}
          onSelect={setSelectedAvatar}
        />
      ) : (
        <BackgroundGrid
          selectedBackground={selectedBackground}
          onSelect={setSelectedBackground}
        />
      )}
    </div>
  );
};

export default ViewAllAvatars;
