import { BrowserRouter as Router, Routes, Route} from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import ADashboard from './pages/ADashboard';
import AllUsersPage from './pages/ViewAllUsers';
import ViewAUser from '../src/components/ViewAUser';

const App = () => {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<LoginPage />} />
                <Route path="/dashboard" element={<ADashboard/>} />
                <Route path="/All-Users" element={<AllUsersPage />} />
                <Route path="/users/:id" element={<ViewAUser />} />
            </Routes>
        </Router>
    );
};

export default App;