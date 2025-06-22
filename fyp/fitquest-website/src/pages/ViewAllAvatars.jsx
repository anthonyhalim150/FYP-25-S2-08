import React, { useState } from 'react';
import AvatarSlider from '../components/AvatarSlider';
import BackgroundSlider from '../components/BackgroundSlider';
import '../styles/Styles.css';

import NavigationBar from '../components/NavigationBar';

const ViewAllAvatars = () => {
  const [tab, setTab] = useState('avatar');
  const [selectedAvatar, setSelectedAvatar] = useState(null);
  const [selectedBackground, setSelectedBackground] = useState(null);
  const [currentBgItem, setCurrentBgItem] = useState(null);

  return (
    <div className="all-workouts-container">
    <header className="admin-header">
      <img src="/white-logo.png" alt="FitQuest Logo" className="logo"/>
      <NavigationBar />
    </header>

      <div className="avatar-tabs">
        {/* <div className="upload-btn-wrapper">
        {tab === 'avatar' ? (
            <button className="upload-btn" onClick={() => console.log('Upload New Avatar')}>
            Upload New Avatar
            </button>
        ) : (
            <button className="upload-btn" onClick={() => console.log('Upload New Background')}>
            Upload New Background
            </button>
        )}
        </div> */}

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

      {tab === 'avatar' ? (
        <AvatarSlider
          avatars={[
            { id: 'a1', name: 'Avatar 1', image: '/avatar1.png' },
            { id: 'a2', name: 'Avatar 2', image: '/avatar2.png' },
            { id: 'a3', name: 'Avatar 3', image: '/avatar3.png' },
          ]}
          onSelect={setSelectedAvatar}
        />
      ) : (
        <>
          <BackgroundSlider
            selectedBackground={selectedBackground}
            onSelect={setSelectedBackground}
            onChangeIndex={(bg) => setCurrentBgItem(bg)}
          />

          <div className="delete-btn-wrapper">
            <button
              className="delete-btn-below"
              onClick={() => console.log('Delete background:', currentBgItem?.id)}
            >
              Delete
            </button>
          </div>
        </>
      )}
    </div>
  );
};

export default ViewAllAvatars;
