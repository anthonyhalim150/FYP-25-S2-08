export async function login({ email, password }) {
  const res = await fetch("http://localhost:8080/login", {
    method: "POST",
    credentials: "include",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password })
  });

  if (!res.ok) {
    const error = await res.json();
    throw new Error(error.message);
  }
  return res.json();
}

export async function checkSession() {
  const res = await fetch("http://localhost:8080/me", {
    method: "GET",
    credentials: "include"
  });

  if (!res.ok) {
    return { loggedIn: false };
  }
  const data = await res.json();
  return { loggedIn: data.message === "logged in" };
}
