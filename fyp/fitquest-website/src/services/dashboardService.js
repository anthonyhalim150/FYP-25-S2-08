export async function fetchDashboardStats() {
  const res = await fetch('http://localhost:8080/api/admin/stats', {
    credentials: 'include'
  });
  if (!res.ok) throw new Error('Failed to fetch stats');
  return res.json();
}
