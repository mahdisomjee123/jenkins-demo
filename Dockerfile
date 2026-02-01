FROM node:18-alpine

WORKDIR /app

# Backend
COPY backend ./backend
WORKDIR /app/backend
RUN npm install

# Frontend
WORKDIR /app
COPY frontend ./frontend

EXPOSE 10000

CMD sh -c "node backend/server.js & npx serve frontend -l 10000"