import { BrowserRouter as Router, Routes, Route} from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import ADashboard from './pages/ADashboard';


const App = () => {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<LoginPage />} />
                <Route path="/dashboard" element={<ADashboard/>} />
                
            </Routes>
        </Router>
    );
};

export default App;