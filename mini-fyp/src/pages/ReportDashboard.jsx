import React, { useState } from 'react';
import '../styles/components/ReportDashboard.css';

function ReportDashboard() {
  const [reportType, setReportType] = useState('daily');

  const getReportData = () => {
    switch (reportType) {
      case 'daily':
        return '8 new bookings today';
      case 'weekly':
        return '54 bookings this week';
      case 'monthly':
        return '212 bookings this month';
      default:
        return '';
    }
  };

  return (
    <div className="reportContainer">
      <h2>Platform Reports</h2>
      <select
        value={reportType}
        onChange={(e) => setReportType(e.target.value)}
        className="reportSelect"
      >
        <option value="daily">Daily</option>
        <option value="weekly">Weekly</option>
        <option value="monthly">Monthly</option>
      </select>
      <div className="reportBox">
        <p><strong>Report:</strong> {getReportData()}</p>
      </div>
    </div>
  );
}

export default ReportDashboard;
