import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import ADashboard from './pages/ADashboard';
import AllUsersPage from './pages/ViewAllUsers';
import ViewAUser from './components/ViewAUser';
import ViewAllWorkoutCategories from './pages/ViewAllWorkoutCategories';
import ViewAWorkoutCategory from './pages/ViewAWorkoutCategory';
import ViewAllAvatars from './pages/ViewAllAvatars';
import ViewAllFeedbacks from './pages/ViewAllFeedbacks';
import ViewAllTournaments from './pages/ViewAllTournaments';
import ViewATournament from './components/ViewATournament';
import CreateTournament from './components/CreateTournament';

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/dashboard" element={<ADashboard />} />
        <Route path="/All-Users" element={<AllUsersPage />} />
        <Route path="/users/:id" element={<ViewAUser />} />
        <Route path="/All-Workouts" element={<ViewAllWorkoutCategories />} />
        <Route path="/admin/workouts/:categoryId" element={<ViewAWorkoutCategory />} />
        <Route path="/All-Avatars" element={<ViewAllAvatars />} />
        <Route path='/All-Feedbacks' element={<ViewAllFeedbacks />} />
        <Route path='All-Tournaments' element={ <ViewAllTournaments/>} />
        <Route path='/create-tournament' element={ <CreateTournament/>} />
        <Route path='/View-Tournament' element={ <ViewATournament/>} />
      </Routes>
    </Router>
  );
};

export default App;
