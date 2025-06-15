import React from 'react';
import '../styles/Styles.css';

const dummyBackgrounds = [
  { id: 'b1', name: 'Beach', image: '/bg-beach.jpeg' },
  { id: 'b2', name: 'Bird', image: '/bg-bird.jpg' },
  { id: 'b3', name: 'Forest', image: '/bg-forest.jpg' },
  { id: 'b4', name: 'Vampire', image: '/bg-vampire.jpg' },
  { id: 'b5', name: 'Night', image: '/bg-night.png' },
  { id: 'b6', name: 'Pink', image: '/bg-pink.jpg' },
];

const BackgroundGrid = ({ selectedBackground, onSelect }) => {
  const handleDelete = (id) => {
    console.log('Delete background:', id);
    // TODO: Implement delete logic
  };

  return (
    <div className="avatar-grid">
      {dummyBackgrounds.map((bg) => (
        <div
          key={bg.id}
          className={`avatar-tile ${selectedBackground === bg.id ? 'selected' : ''}`}
          onClick={() => onSelect(bg.id)}
        >
          <img src={bg.image} alt={bg.name} className="avatar-image" />
          <div className="avatar-actions">
            <button className="delete-btn" onClick={(e) => {
              e.stopPropagation();
              handleDelete(bg.id);
            }}>Delete</button>
          </div>
        </div>
      ))}
    </div>
  );
};

export default BackgroundGrid;
