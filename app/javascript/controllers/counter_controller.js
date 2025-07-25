import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  
  // Use Stimulus actions instead of manual event listeners for better Turbo compatibility
  handleTouchStart(event) {
    event.target.style.transform = 'scale(0.95)'
    event.target.style.opacity = '0.8'
  }
  
  handleTouchEnd(event) {
    event.target.style.transform = 'scale(1)'
    event.target.style.opacity = '1'
  }
  
  handleMouseDown(event) {
    this.handleTouchStart(event)
  }
  
  handleMouseUp(event) {
    this.handleTouchEnd(event)
  }
}
