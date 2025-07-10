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
