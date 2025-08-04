// BMX Race Tracker Service Worker
// Provides offline capability and performance optimization

const CACHE_NAME = 'bmx-race-tracker-v2'
const STATIC_CACHE_URLS = [
  '/',
  '/assets/application.css',
  '/assets/application.js',
  '/icon.png',
  '/icon.svg'
]

// Install event - cache static assets
self.addEventListener('install', (event) => {
  console.log('Service Worker: Installing...')
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('Service Worker: Caching static assets')
        return cache.addAll(STATIC_CACHE_URLS)
      })
      .catch((error) => {
        console.error('Service Worker: Cache failed', error)
      })
  )
  self.skipWaiting()
})

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('Service Worker: Activating...')
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Service Worker: Deleting old cache', cacheName)
            return caches.delete(cacheName)
          }
        })
      )
    })
  )
  self.clients.claim()
})

// Fetch event - serve from cache when offline
self.addEventListener('fetch', (event) => {
  // Skip non-GET requests
  if (event.request.method !== 'GET') {
    return
  }

  // Skip cross-origin requests
  if (!event.request.url.startsWith(self.location.origin)) {
    return
  }

  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        // Return cached version if available
        if (response) {
          console.log('Service Worker: Serving from cache', event.request.url)
          return response
        }

        // Otherwise, fetch from network
        return fetch(event.request)
          .then((response) => {
            // Don't cache non-successful responses
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response
            }

            // Cache successful responses for club pages (but NOT admin pages)
            if (event.request.url.match(/\/[a-z0-9\-]+\/?$/) && !event.request.url.includes('/admin')) {
              const responseToCache = response.clone()
              caches.open(CACHE_NAME)
                .then((cache) => {
                  cache.put(event.request, responseToCache)
                })
            }

            return response
          })
          .catch(() => {
            // Serve offline page for navigation requests when offline
            if (event.request.mode === 'navigate') {
              return new Response(`
                <!DOCTYPE html>
                <html>
                  <head>
                    <title>BMX Race Tracker - Offline</title>
                    <meta name="viewport" content="width=device-width,initial-scale=1">
                    <style>
                      body { font-family: sans-serif; text-align: center; padding: 50px; background: #f5f5f5; }
                      .offline-message { background: white; padding: 30px; border-radius: 10px; display: inline-block; }
                      .icon { font-size: 48px; margin-bottom: 20px; }
                    </style>
                  </head>
                  <body>
                    <div class="offline-message">
                      <div class="icon">📶</div>
                      <h1>You're Offline</h1>
                      <p>BMX Race Tracker requires an internet connection.</p>
                      <p>Please check your connection and try again.</p>
                      <button onclick="location.reload()">Retry</button>
                    </div>
                  </body>
                </html>
              `, {
                headers: { 'Content-Type': 'text/html' }
              })
            }
          })
      })
  )
})

// Background sync for counter updates when reconnected
self.addEventListener('sync', (event) => {
  console.log('Service Worker: Background sync', event.tag)
  
  if (event.tag === 'counter-update') {
    event.waitUntil(
      // Handle queued counter updates when connection is restored
      handleQueuedCounterUpdates()
    )
  }
})

async function handleQueuedCounterUpdates() {
  // This would integrate with IndexedDB to sync queued updates
  // For now, just log that sync is available
  console.log('Service Worker: Ready to sync counter updates')
}

// Web Push notifications support
self.addEventListener("push", async (event) => {
  if (event.data) {
    const { title, options } = await event.data.json()
    event.waitUntil(self.registration.showNotification(title, options))
  }
})

self.addEventListener("notificationclick", function(event) {
  event.notification.close()
  event.waitUntil(
    clients.matchAll({ type: "window" }).then((clientList) => {
      for (let i = 0; i < clientList.length; i++) {
        let client = clientList[i]
        let clientPath = (new URL(client.url)).pathname

        if (clientPath == event.notification.data.path && "focus" in client) {
          return client.focus()
        }
      }

      if (clients.openWindow) {
        return clients.openWindow(event.notification.data.path)
      }
    })
  )
})
