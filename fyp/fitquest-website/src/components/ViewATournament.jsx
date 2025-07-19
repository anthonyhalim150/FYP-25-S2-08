import React, {useState} from 'react';
import '../styles/Styles.css';
import { useNavigate } from 'react-router-dom';



const ViewATournament = ({ tournament, onClose }) => {
    const navigate = useNavigate();
    const [isEditing, setIsEditing] = useState(false);
    const [editedTournament, setEditedTournament] = useState({...tournament });

    if (!tournament) return null;

  return (
    <div className="view-tournament-modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <button className="modal-close" onClick={onClose}>✕</button>
        <h2 className="pixel-font">{isEditing ? 'Edit Tournament' : 'View Tournament'}</h2>

        <label>Title*</label>
        {isEditing ? (
          <input
            type="text"
            value={editedTournament.title}
            onChange={(e) =>
              setEditedTournament({ ...editedTournament, title: e.target.value })
            }
          />
        ) : (
          <p>{tournament.title}</p>
        )}

       <label>Description*</label>
      {isEditing ? (
        <textarea
          value={editedTournament.description}
          rows={4}
          onChange={(e) =>
            setEditedTournament({ ...editedTournament, description: e.target.value })
          }
        />
      ) : (
        <p>{tournament.description}</p>
      )}

        <label>Date*</label>

        <div className="date-group-row">
          <span>Start date</span>
          <div className="date-time-inputs">
            { isEditing ? (
            <>
            <input 
            type = "date"
            value = {editedTournament.startDate}
            onChange= {(e) => setEditedTournament({...editedTournament, startDate: e.target.value})
            }/>

            <input 
            type = "date"
            value = {editedTournament.startTime || '00:00'}
            onChange = {(e) => setEditedTournament({...editedTournament, startTime: e.target.value})
            }/>

            </>
            ): ( 
            <p> {`${tournament.startDate} ${tournament.startTime || '00:00' }`}</p>
            )}

          </div>
        </div>

        <div className="date-group-row">
          <span>End Time</span>
          <div className="date-time-inputs">
            { isEditing ? (
            <>
            <input 
            type = "date"
            value = {editedTournament.endDate}
            onChange= {(e) => setEditedTournament({...editedTournament, endDate: e.target.value})
            }/>

            <input 
            type = "date"
            value = {editedTournament.endTime || '00:00'}
            onChange = {(e) => setEditedTournament({...editedTournament, endTime  : e.target.value})
            }/>

            </>
            ): ( 
            <p> {`${tournament.endDate} ${tournament.endTime || '00:00' }`}</p>
            )}

          </div>
        </div>

        <div className="form-row-2col">
          <div className="form-group-col">
            <label>Workout Category*</label>
            {isEditing ? (
              <select
                value={editedTournament.category}
                onChange={(e) =>
                  setEditedTournament({ ...editedTournament, category: e.target.value })
                }
              >
                <option value="All Workout">All Workout</option>
                <option value="Strength">Strength</option>
                <option value="Cardio">Cardio</option>
                <option value="Mobility">Mobility</option>
                <option value="Flexibility">Flexibility</option>
              </select>
            ) : (
              <p>{tournament.category || 'All Workout'}</p>
            )}
          </div>

          <div className="form-group-col">
            <label>Reward*</label>
            {isEditing ? (
              <select
                value={editedTournament.prize}
                onChange={(e) =>
                  setEditedTournament({ ...editedTournament, prize: e.target.value })
                }
              >
                <option value="Reward A">Reward A</option>
                <option value="Yoga Mat">Yoga Mat</option>
                <option value="Badge Unlock">Badge Unlock</option>
                <option value="FitQuest Gym Bag">FitQuest Gym Bag</option>
                <option value="Summer Edition FitQuest Shirt">Summer Edition FitQuest Shirt</option>
              </select>
            ) : (
              <p>{tournament.prize || 'Reward A'}</p>
            )}
          </div>
        </div>


       <div className="button-row">
        {isEditing ? (
          <>
            <button className="cancel-btn" onClick={() => {
              setEditedTournament({ ...tournament });
              setIsEditing(false);
            }}>
              Cancel
            </button>
            <button className="confirm-btn" onClick={() => {
              console.log('Saving tournament:', editedTournament);
              setIsEditing(false);
            }}>
              Save
            </button>
          </>
        ) : (
          <button className="edit-btn" onClick={() => setIsEditing(true)}>
            Edit
          </button>
        )}
      </div>

      </div>
    </div>
  );
};

export default ViewATournament;
