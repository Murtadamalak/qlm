// Firebase Messaging service worker placeholder.
// If you enable web push, replace these values during deployment or manage
// notifications from a backend Cloud Function using stored FCM tokens.
self.addEventListener('push', (event) => {
  const data = event.data ? event.data.json() : {};
  const title = data.notification?.title || 'E-Library & Printing';
  const options = {
    body: data.notification?.body || 'You have a new update.',
    data: data.data || {},
  };
  event.waitUntil(self.registration.showNotification(title, options));
});
