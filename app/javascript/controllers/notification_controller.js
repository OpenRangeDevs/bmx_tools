import { Controller } from "@hotwired/stimulus"

// Notification Controller with smooth slide-in animations
export default class extends Controller {
  static targets = ["message"]
  static values = { 
    autoHide: { type: Boolean, default: true },
    hideDelay: { type: Number, default: 5000 },
    position: { type: String, default: "top" }
  }

  connect() {
    this.show()
    
    if (this.autoHideValue) {
      this.scheduleHide()
    }
  }

  // Show notification with slide-in animation
  show() {
    this.element.classList.remove('hidden')
    
    // Initial state - hidden off-screen
    if (this.positionValue === 'top') {
      this.element.style.transform = 'translateY(-100%)'
    } else {
      this.element.style.transform = 'translateY(100%)'
    }
    
    this.element.style.opacity = '0'
    this.element.style.transition = 'all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1)'
    
    // Trigger animation
    requestAnimationFrame(() => {
      this.element.style.transform = 'translateY(0)'
      this.element.style.opacity = '1'
    })
    
    // Add entrance effect
    setTimeout(() => {
      this.element.style.transform = 'translateY(-2px)'
      setTimeout(() => {
        this.element.style.transform = 'translateY(0)'
      }, 150)
    }, 200)
  }

  // Hide notification with slide-out animation
  hide() {
    this.element.style.transition = 'all 0.3s ease-in-out'
    
    if (this.positionValue === 'top') {
      this.element.style.transform = 'translateY(-100%)'
    } else {
      this.element.style.transform = 'translateY(100%)'
    }
    
    this.element.style.opacity = '0'
    
    // Remove from DOM after animation
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 300)
  }

  // Schedule auto-hide
  scheduleHide() {
    this.hideTimeout = setTimeout(() => {
      this.hide()
    }, this.hideDelayValue)
  }

  // Cancel auto-hide (useful when user hovers)
  cancelHide() {
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout)
      this.hideTimeout = null
    }
  }

  // Pause auto-hide on hover
  pause() {
    this.cancelHide()
  }

  // Resume auto-hide when not hovering
  resume() {
    if (this.autoHideValue) {
      this.scheduleHide()
    }
  }

  // Manual close action
  close() {
    this.cancelHide()
    this.hide()
  }

  // Animate priority change (for countdown timers)
  updatePriority(priority) {
    const priorityClasses = {
      'low': 'bg-green-100 border-green-300 text-green-800',
      'medium': 'bg-yellow-100 border-yellow-300 text-yellow-800',
      'high': 'bg-orange-100 border-orange-300 text-orange-800',
      'critical': 'bg-red-100 border-red-300 text-red-800'
    }
    
    // Remove existing priority classes
    Object.values(priorityClasses).forEach(classes => {
      classes.split(' ').forEach(cls => {
        this.element.classList.remove(cls)
      })
    })
    
    // Add new priority classes with animation
    this.element.style.transition = 'all 0.3s ease-in-out'
    
    if (priorityClasses[priority]) {
      priorityClasses[priority].split(' ').forEach(cls => {
        this.element.classList.add(cls)
      })
      
      // Pulse effect for high priority
      if (priority === 'high' || priority === 'critical') {
        this.element.style.transform = 'scale(1.02)'
        setTimeout(() => {
          this.element.style.transform = 'scale(1)'
        }, 200)
      }
    }
  }

  disconnect() {
    this.cancelHide()
  }
}