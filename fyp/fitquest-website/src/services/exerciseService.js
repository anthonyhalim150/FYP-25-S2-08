export async function fetchAllExercises() {
    const res = await fetch('http://localhost:8080/admin/exercises', {
      credentials: 'include'
    });
    if (!res.ok) throw new Error('Failed to fetch exercises');
    return res.json();
  }
  