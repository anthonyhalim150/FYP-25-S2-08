import React, {useState} from 'react';
import Swal from 'sweetalert2';
import '../styles/Styles.css';

const ViewAUser = ({ user, onClose }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [editedUser, setEditedUser] = useState({ ...user });
  
  if (!user) return null;

  const handleSave = async () => {
    const fieldsToCheck = ['first_name', 'last_name', 'dob', 'email', 'account', 'level'];
    const hasChanged = fieldsToCheck.some(field => editedUser[field] !== user[field]);

    if (!hasChanged) {
      await Swal.fire({
        title: 'No changes detected',
        text: 'You haven’t modified any details.',
        icon: 'info',
        confirmButtonText: 'OK',
        buttonsStyling: false,
        customClass: { confirmButton: 'confirm-btn' }
      });
      return;
    }

    const result = await Swal.fire({
      title: 'Save changes?',
      text: 'Are you sure you want to update this user\'s details?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes, save',
      cancelButtonText: 'Cancel',
      buttonsStyling: false,
      customClass: {
        confirmButton: 'confirm-btn',
        cancelButton: 'cancel-btn'
      }
    });

    if (result.isConfirmed) {
      console.log('Saved user:', editedUser); // Replace with backend call
      setIsEditing(false);

      await Swal.fire({
        title: 'Success',
        text: 'User details have been updated.',
        icon: 'success',
        confirmButtonText: 'OK',
        buttonsStyling: false,
        customClass: { confirmButton: 'confirm-btn' }
      });
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div
          className="modal-content user-modal-split"
          onClick={(e) => e.stopPropagation()}
          style={{
            backgroundImage: `url(/backgrounds/bg${user.background_id || 1}.jpg)`,
            backgroundSize: 'cover',
            backgroundRepeat: 'no-repeat',
            backgroundPosition: 'center'
          }}
        >
        <button className="modal-close" onClick={onClose}>✕</button>

        {/* Left Yellow Panel */}
        <div className="user-info-panel">
          <img
            src={`/avatars/avatar${user.avatar_id || 1}.png`}
            alt="User Avatar"
            className="user-avatar-large"
          />

          
          <h2>{user.username}</h2>

          <p><strong>First Name:</strong> {isEditing ? (
            <input
              type="text"
              value={editedUser.first_name}
              onChange = { (e) => setEditedUser({ ...editedUser, first_name: e.target.value}) } />
              ) : user.first_name}</p>

          
          <p><strong>Last Name:</strong> { isEditing ? (
            <input  
              type="text"
              value= {editedUser.last_name}
              onChange = {(e) => setEditedUser({ ...editedUser, last_name: e.target.value})} />
              ) : user.last_name}</p>

          <p><strong>Date of Birth:</strong> { isEditing ? (
            <input 
              type="date"
              value={editedUser.dob}
              onChange={(e) => setEditedUser({ ...editedUser, dob: e.target.value})}
            />
          ) : user.dob} </p>
          
          <p><strong>Email:</strong> { isEditing ? (
            <input  
              type="text"
              value= {editedUser.email}
              onChange = {(e) => setEditedUser({ ...editedUser, email: e.target.value})} />
              ) : user.email}</p>

          <p><strong>Account:</strong> { isEditing ? (
            <input  
              type="text"
              value= {editedUser.account}
              onChange = {(e) => setEditedUser({ ...editedUser, account: e.target.value})} />
              ) : user.account}</p>
          
          <p><strong>Level:</strong> { isEditing ? (
            <input  
              type="text"
              value= {editedUser.level}
              onChange = {(e) => setEditedUser({ ...editedUser, level: e.target.value})} />
              ) : user.level}</p>

        {isEditing ? (
          <div className="button-row">
            <button 
            className="confirm-btn" 
            onClick={handleSave}>Save</button>
            <button
              className="cancel-btn"
              onClick={() => {
                setEditedUser({ ...user });
                setIsEditing(false);
              }}>Cancel</button>
          </div>
        ) : (
          <div className='button-row center'>
          <button className="edit-btn" onClick={() => setIsEditing(true)}>Edit</button>
           <button className={user.isSuspended ? 'unsuspend-btn' : 'suspend-btn'}>
              {user.isSuspended ? 'Unsuspend' : 'Suspend'}
            </button>
          </div>
        )}

        </div>

        {/* Right Preferences Panel */}
        <div className="user-preferences-panel">
          <h3>User Preferences</h3>
          <ul>
            <li><strong>Workout Frequency:</strong> {user.preferences.workout_frequency}</li>
            <li><strong>Fitness Goal:</strong> {user.preferences.fitness_goal}</li>
            <li><strong>Workout Time:</strong> {user.preferences.workout_time}</li>
            <li><strong>Fitness Level:</strong> {user.preferences.fitness_level}</li>
            <li><strong>Injury:</strong> {user.preferences.injury}</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default ViewAUser;
