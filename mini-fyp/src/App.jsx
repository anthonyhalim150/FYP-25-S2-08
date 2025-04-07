import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';

import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import Dashboard from './pages/Dashboard';
import CleanerProfile from './pages/CleanerProfile';
import SearchPage from './pages/SearchPage';
import ShortlistPage from './pages/ShortlistPage';
import MatchHistoryPage from './pages/MatchHistoryPage';
import ReportDashboard from './pages/ReportDashboard';

function App() {
  return (
    <>
      <Navbar />
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/search" element={<SearchPage />} />
        <Route path="/shortlist" element={<ShortlistPage />} />
        <Route path="/cleaner/:id" element={<CleanerProfile />} />
        <Route path="/match-history" element={<MatchHistoryPage />} />
        <Route path="/reports" element={<ReportDashboard />} />
      </Routes>
    </>
  );
}

export default App;
