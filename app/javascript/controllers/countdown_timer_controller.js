import { Controller } from "@hotwired/stimulus"

// Countdown Timer Controller
// Provides real-time countdown functionality for race events
export default class extends Controller {
  static targets = ["display", "label"]
  static values = { 
    targetTime: String,
    autoStart: { type: Boolean, default: true },
    showNotifications: { type: Boolean, default: true }
  }

  connect() {
    this.updateInterval = null
    if (this.autoStartValue && this.targetTimeValue) {
      this.start()
    }
  }

  disconnect() {
    this.stop()
  }

  start() {
    if (!this.targetTimeValue) return
    
    this.targetDate = new Date(this.targetTimeValue)
    if (isNaN(this.targetDate.getTime())) {
      console.error("Invalid target time:", this.targetTimeValue)
      return
    }

    this.updateDisplay()
    this.updateInterval = setInterval(() => {
      this.updateDisplay()
    }, 1000)
  }

  stop() {
    if (this.updateInterval) {
      clearInterval(this.updateInterval)
      this.updateInterval = null
    }
  }

  updateDisplay() {
    const now = new Date()
    const timeLeft = this.targetDate - now

    if (timeLeft <= 0) {
      this.handleExpired()
      return
    }

    const formatted = this.formatTimeLeft(timeLeft)
    this.displayTarget.textContent = formatted.display
    
    // Update styling based on urgency
    this.updateStyling(timeLeft)
    
    // Show notifications at key intervals
    if (this.showNotificationsValue) {
      this.checkNotificationThresholds(timeLeft)
    }
  }

  formatTimeLeft(milliseconds) {
    const totalSeconds = Math.floor(milliseconds / 1000)
    const hours = Math.floor(totalSeconds / 3600)
    const minutes = Math.floor((totalSeconds % 3600) / 60)
    const seconds = totalSeconds % 60

    if (hours > 0) {
      return {
        display: `${hours}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`,
        urgency: 'none'
      }
    } else if (minutes > 10) {
      return {
        display: `${minutes}:${seconds.toString().padStart(2, '0')}`,
        urgency: 'none'
      }
    } else if (minutes > 5) {
      return {
        display: `${minutes}:${seconds.toString().padStart(2, '0')}`,
        urgency: 'low'
      }
    } else if (minutes > 1) {
      return {
        display: `${minutes}:${seconds.toString().padStart(2, '0')}`,
        urgency: 'medium'
      }
    } else {
      return {
        display: `${seconds}s`,
        urgency: 'high'
      }
    }
  }

  updateStyling(timeLeft) {
    const totalMinutes = Math.floor(timeLeft / (1000 * 60))
    
    // Remove existing urgency classes
    this.displayTarget.classList.remove('text-green-600', 'text-yellow-600', 'text-orange-600', 'text-red-600', 'animate-pulse')
    
    if (totalMinutes > 10) {
      this.displayTarget.classList.add('text-green-600')
    } else if (totalMinutes > 5) {
      this.displayTarget.classList.add('text-yellow-600')
    } else if (totalMinutes > 1) {
      this.displayTarget.classList.add('text-orange-600')
    } else {
      this.displayTarget.classList.add('text-red-600', 'animate-pulse')
    }
  }

  checkNotificationThresholds(timeLeft) {
    const totalMinutes = Math.floor(timeLeft / (1000 * 60))
    const totalSeconds = Math.floor(timeLeft / 1000)
    
    // Store notifications we've already shown
    if (!this.shownNotifications) {
      this.shownNotifications = new Set()
    }

    const notifications = [
      { threshold: 15 * 60, message: "15 minutes remaining" },
      { threshold: 10 * 60, message: "10 minutes remaining" },
      { threshold: 5 * 60, message: "5 minutes remaining" },
      { threshold: 2 * 60, message: "2 minutes remaining" },
      { threshold: 60, message: "1 minute remaining" },
      { threshold: 30, message: "30 seconds remaining!" },
      { threshold: 10, message: "10 seconds!" }
    ]

    notifications.forEach(({ threshold, message }) => {
      if (totalSeconds <= threshold && !this.shownNotifications.has(threshold)) {
        this.showNotification(message)
        this.shownNotifications.add(threshold)
      }
    })
  }

  showNotification(message) {
    // Dispatch custom event for other components to handle
    this.dispatch("notification", { 
      detail: { 
        message, 
        type: "countdown",
        targetTime: this.targetTimeValue 
      }
    })

    // Optional: Show browser notification if permission granted
    if ("Notification" in window && Notification.permission === "granted") {
      new Notification("BMX Race Timer", {
        body: message,
        icon: "/favicon.ico",
        badge: "/favicon.ico"
      })
    }
  }

  handleExpired() {
    this.stop()
    this.displayTarget.textContent = "Time's Up!"
    this.displayTarget.classList.remove('text-green-600', 'text-yellow-600', 'text-orange-600')
    this.displayTarget.classList.add('text-red-600', 'font-bold', 'animate-pulse')
    
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = "Event Started"
    }

    this.dispatch("expired", { 
      detail: { 
        targetTime: this.targetTimeValue,
        element: this.element 
      }
    })

    // Show final notification
    this.showNotification("Event time has arrived!")
  }

  // Action to update the target time dynamically
  updateTarget(event) {
    const newTarget = event.detail?.targetTime || event.target.dataset.targetTime
    if (newTarget) {
      this.targetTimeValue = newTarget
      this.stop()
      this.start()
    }
  }

  // Action to reset notification tracking
  resetNotifications() {
    this.shownNotifications = new Set()
  }
}