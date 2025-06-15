import React from 'react';
import '../styles/Styles.css';

const dummyAvatars = [
  { id: 'a1', name: 'Avatar 1', image: '/avatar1.png' },
  { id: 'a2', name: 'Avatar 2', image: '/avatar2.png' },
  { id: 'a3', name: 'Avatar 3', image: '/avatar3.png' },
  { id: 'a4', name: 'Avatar 4', image: '/avatar4.png' },
  { id: 'a5', name: 'Avatar 5', image: '/avatar5.png' },
  { id: 'a6', name: 'Avatar 6', image: '/avatar6.png' },
];

const AvatarGrid = ({ selectedAvatar, onSelect }) => {
  const handleDelete = (id) => {
    console.log('Delete avatar:', id);
    // TODO: Implement delete logic
  };

  return (
    <div className="avatar-grid">
      {dummyAvatars.map((avatar) => (
        <div
          key={avatar.id}
          className={`avatar-tile ${selectedAvatar === avatar.id ? 'selected' : ''}`}
          onClick={() => onSelect(avatar.id)}
        >
          <img src={avatar.image} alt={avatar.name} className="avatar-image" />
          <div className="avatar-actions">
            <button className="delete-btn" onClick={(e) => {
              e.stopPropagation();
              handleDelete(avatar.id);
            }}>Delete</button>
          </div>
        </div>
      ))}
    </div>
  );
};

export default AvatarGrid;
