import { Controller } from "@hotwired/stimulus"

// Connection Status Controller
// Monitors WebSocket connection and provides visual feedback
export default class extends Controller {
  static targets = ["indicator", "message"]
  static values = { 
    reconnectDelay: { type: Number, default: 3000 },
    maxReconnectAttempts: { type: Number, default: 5 }
  }

  connect() {
    this.reconnectAttempts = 0
    this.setupConnectionMonitoring()
    this.updateStatus("connected")
  }

  disconnect() {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer)
    }
  }

  setupConnectionMonitoring() {
    // Monitor Turbo Stream connection status
    document.addEventListener("turbo:connected", this.handleConnected.bind(this))
    document.addEventListener("turbo:disconnected", this.handleDisconnected.bind(this))
    document.addEventListener("turbo:connect-failed", this.handleConnectionFailed.bind(this))
    
    // Monitor visibility changes to handle mobile app switching
    document.addEventListener("visibilitychange", this.handleVisibilityChange.bind(this))
  }

  handleConnected() {
    this.reconnectAttempts = 0
    this.updateStatus("connected")
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer)
      this.reconnectTimer = null
    }
  }

  handleDisconnected() {
    this.updateStatus("disconnected")
    this.scheduleReconnect()
  }

  handleConnectionFailed() {
    this.updateStatus("failed")
    this.scheduleReconnect()
  }

  handleVisibilityChange() {
    if (!document.hidden) {
      // Page became visible, check connection
      this.checkConnection()
    }
  }

  scheduleReconnect() {
    if (this.reconnectAttempts >= this.maxReconnectAttemptsValue) {
      this.updateStatus("failed")
      return
    }

    this.reconnectAttempts++
    this.updateStatus("reconnecting")
    
    this.reconnectTimer = setTimeout(() => {
      this.attemptReconnect()
    }, this.reconnectDelayValue * this.reconnectAttempts)
  }

  attemptReconnect() {
    // Force Turbo to reconnect by triggering a page refresh
    // This is the most reliable way with Turbo Streams
    if (navigator.onLine) {
      location.reload()
    } else {
      this.updateStatus("offline")
      this.scheduleReconnect()
    }
  }

  checkConnection() {
    // Simple connectivity check
    if (!navigator.onLine) {
      this.updateStatus("offline")
      return
    }

    // Send a lightweight request to verify server connectivity
    fetch(window.location.href, { 
      method: 'HEAD',
      cache: 'no-cache'
    })
    .then(response => {
      if (response.ok) {
        this.handleConnected()
      } else {
        this.handleConnectionFailed()
      }
    })
    .catch(() => {
      this.handleConnectionFailed()
    })
  }

  updateStatus(status) {
    const indicator = this.hasIndicatorTarget ? this.indicatorTarget : null
    const message = this.hasMessageTarget ? this.messageTarget : null

    const statusConfig = {
      connected: {
        color: "bg-green-500",
        text: "Connected",
        icon: "🟢"
      },
      disconnected: {
        color: "bg-yellow-500",
        text: "Disconnected",
        icon: "🟡"
      },
      reconnecting: {
        color: "bg-blue-500",
        text: `Reconnecting... (${this.reconnectAttempts}/${this.maxReconnectAttemptsValue})`,
        icon: "🔄"
      },
      failed: {
        color: "bg-red-500",
        text: "Connection Failed",
        icon: "🔴"
      },
      offline: {
        color: "bg-gray-500",
        text: "Offline",
        icon: "📶"
      }
    }

    const config = statusConfig[status] || statusConfig.disconnected

    if (indicator) {
      indicator.className = `inline-block w-3 h-3 rounded-full ${config.color} mr-2`
    }

    if (message) {
      message.textContent = `${config.icon} ${config.text}`
      
      // Add status-specific classes for styling
      message.className = message.className.replace(/status-\w+/g, '')
      message.classList.add(`status-${status}`)
    }

    // Store current status for other controllers
    this.element.dataset.connectionStatus = status
    
    // Dispatch custom event for other components
    this.dispatch("statusChanged", { 
      detail: { status, config, attempts: this.reconnectAttempts }
    })
  }

  // Action to manually trigger reconnection
  reconnect() {
    this.reconnectAttempts = 0
    this.checkConnection()
  }
}