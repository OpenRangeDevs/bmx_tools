import { Controller } from "@hotwired/stimulus"

// Enhanced Counter Controller with smooth animations
export default class extends Controller {
  static targets = ["display", "value"]
  
  connect() {
    // Add CSS transition for smooth animations
    this.element.style.transition = 'all 0.2s ease-in-out'
  }
  
  // Enhanced touch/click feedback with smooth animations
  handleTouchStart(event) {
    this.animatePress(event.target)
    
    // Add haptic feedback if available
    if (navigator.vibrate) {
      navigator.vibrate(10) // Short vibration
    }
  }
  
  handleTouchEnd(event) {
    this.animateRelease(event.target)
  }
  
  handleMouseDown(event) {
    this.animatePress(event.target)
  }
  
  handleMouseUp(event) {
    this.animateRelease(event.target)
  }
  
  // Smooth press animation
  animatePress(element) {
    element.style.transition = 'all 0.1s ease-out'
    element.style.transform = 'scale(0.95)'
    element.style.opacity = '0.8'
    element.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)'
  }
  
  // Smooth release animation
  animateRelease(element) {
    element.style.transition = 'all 0.2s ease-out'
    element.style.transform = 'scale(1)'
    element.style.opacity = '1'
    element.style.boxShadow = '0 4px 8px rgba(0,0,0,0.15)'
    
    // Add a subtle "bounce" effect
    setTimeout(() => {
      element.style.transform = 'scale(1.02)'
      setTimeout(() => {
        element.style.transform = 'scale(1)'
      }, 100)
    }, 50)
  }
  
  // Animate counter value changes
  animateCounterChange(oldValue, newValue) {
    if (this.hasDisplayTarget) {
      const display = this.displayTarget
      
      // Create animation effect for value change
      display.style.transition = 'all 0.3s ease-in-out'
      
      // Briefly highlight the change
      if (newValue > oldValue) {
        // Increment animation - green flash
        display.style.backgroundColor = '#22c55e'
        display.style.color = 'white'
      } else if (newValue < oldValue) {
        // Decrement animation - red flash
        display.style.backgroundColor = '#ef4444'
        display.style.color = 'white'
      }
      
      // Scale animation
      display.style.transform = 'scale(1.1)'
      
      // Reset after animation
      setTimeout(() => {
        display.style.backgroundColor = ''
        display.style.color = ''
        display.style.transform = 'scale(1)'
      }, 300)
    }
  }
  
  // Success feedback animation
  showSuccessFeedback(element) {
    const originalBg = element.style.backgroundColor
    element.style.transition = 'all 0.4s ease-in-out'
    element.style.backgroundColor = '#10b981'
    element.style.transform = 'scale(1.05)'
    
    setTimeout(() => {
      element.style.backgroundColor = originalBg
      element.style.transform = 'scale(1)'
    }, 400)
  }
}
