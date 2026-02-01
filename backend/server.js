const express = require("express");
const app = express();
const port = 8081;

app.get("/api/message", (req, res) => {
  res.send("Hello from Backend API 🎯");
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});