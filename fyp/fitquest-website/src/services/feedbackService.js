export async function fetchFeedbacks({ status = "All", search = "" } = {}) {
    const params = new URLSearchParams();
    if (status) params.append("status", status);
    if (search) params.append("search", search);
  
    const res = await fetch(`http://localhost:8080/admin/feedbacks?${params.toString()}`, {
      method: "GET",
      credentials: "include"
    });
  
    if (!res.ok) {
      const error = await res.json();
      throw new Error(error.message);
    }
    return res.json();
  }
  
  export async function updateFeedbackStatus({ id, status }) {
    const res = await fetch(`http://localhost:8080/admin/feedbacks/${id}/status`, {
      method: "POST",
      credentials: "include",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status })
    });
  
    if (!res.ok) {
      const error = await res.json();
      throw new Error(error.message);
    }
    return res.json();
  }
  export async function fetchFeedbackSummary(limit = 10) {
    const res = await fetch(`http://localhost:8080/admin/feedbacks/summary?limit=${limit}`, {
      method: "GET",
      credentials: "include"
    });
  
    if (!res.ok) {
      const error = await res.json();
      throw new Error(error.message);
    }
    return res.json();
  }
  