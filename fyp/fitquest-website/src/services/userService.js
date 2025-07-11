export async function fetchDashboardStats() {
  const res = await fetch('http://localhost:8080/admin/stats', {
    credentials: 'include'
  });
  if (!res.ok) throw new Error('Failed to fetch stats');
  return res.json();
}
export async function fetchAllUsers() {
  const res = await fetch('http://localhost:8080/admin/users', {
    credentials: 'include'
  });
  if (!res.ok) throw new Error('Failed to fetch users');
  return res.json();
}

