export async function fetchAllTournaments() {
    const res = await fetch('http://localhost:8080/admin/tournaments', {
      credentials: 'include'
    });
    if (!res.ok) throw new Error('Failed to fetch tournaments');
    return res.json();
  }
  
  export async function createTournament(tournamentData) {
    const res = await fetch('http://localhost:8080/admin/tournaments', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify(tournamentData)
    });
    if (!res.ok) throw new Error('Failed to create tournament');
    return res.json();
  }
  
  export async function updateTournament(id, tournamentData) {
    const res = await fetch(`http://localhost:8080/admin/tournaments/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify(tournamentData)
    });
    if (!res.ok) throw new Error('Failed to update tournament');
    return res.json();
  }
  