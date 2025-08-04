import { Controller } from "@hotwired/stimulus"

// Service Worker Controller
// Registers service worker for offline capability and performance optimization
export default class extends Controller {
  static values = { path: String }

  connect() {
    this.registerServiceWorker()
  }

  registerServiceWorker() {
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', () => {
        navigator.serviceWorker.register(this.pathValue)
          .then((registration) => {
            console.log('ServiceWorker registration successful with scope: ', registration.scope)
            
            // Listen for updates to the service worker
            registration.addEventListener('updatefound', () => {
              const newWorker = registration.installing
              
              newWorker.addEventListener('statechange', () => {
                if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
                  // New service worker is available, show update notification
                  this.showUpdateNotification()
                }
              })
            })
          })
          .catch((error) => {
            console.log('ServiceWorker registration failed: ', error)
          })
      })
    }
  }

  showUpdateNotification() {
    // Create a non-intrusive notification that the app has been updated
    const notification = document.createElement('div')
    notification.className = 'fixed bottom-4 right-4 bg-blue-600 text-white px-4 py-2 rounded-lg shadow-lg z-50'
    notification.innerHTML = `
      <div class="flex items-center space-x-2">
        <span>🔄 App updated!</span>
        <button class="bg-blue-700 hover:bg-blue-800 px-2 py-1 rounded text-sm" onclick="location.reload()">
          Refresh
        </button>
        <button class="text-blue-200 hover:text-white" onclick="this.parentElement.parentElement.remove()">
          ✕
        </button>
      </div>
    `
    
    document.body.appendChild(notification)
    
    // Auto-remove after 10 seconds if not interacted with
    setTimeout(() => {
      if (document.body.contains(notification)) {
        notification.remove()
      }
    }, 10000)
  }
}