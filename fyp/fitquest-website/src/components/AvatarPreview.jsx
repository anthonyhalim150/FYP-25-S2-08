import React from 'react';
import '../styles/Styles.css';

const AvatarPreview = ({ avatar, background }) => {
  const avatarImage = avatar ? `/avatar${avatar.slice(1)}.png` : '/avatar-placeholder.png';
  const bgImage = background ? `/bg-${background.slice(1)}.png` : '/bg-placeholder.png';

  return (
    <div className="avatar-preview-container">
      <div
        className="avatar-preview-circle"
        style={{ backgroundImage: `url(${bgImage})` }}
      >
        <img src={avatarImage} alt="Selected Avatar" className="avatar-bounce" />
      </div>
      <p className="avatar-username">@username</p>
    </div>
  );
};

export default AvatarPreview;
