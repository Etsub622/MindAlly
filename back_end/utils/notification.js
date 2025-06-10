// utils/notification.js
import { io } from '../index.js'; // Make sure `io` is exported from your server file

export const sendAppNotification = (userId, message) => {
  console.log(`Notify user ${userId}: ${message}`);

  // Emit to a specific user via socket.io
  io.emit(`notify:${userId}`, { message });
};
