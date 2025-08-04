import { Controller } from "@hotwired/stimulus"

// Keyboard Navigation Controller
// Enhances keyboard accessibility for counter controls
export default class extends Controller {
  static targets = ["increment", "decrement"]
  static values = { 
    counterType: String,
    currentValue: Number 
  }

  connect() {
    // Add keyboard event listeners
    this.element.addEventListener('keydown', this.handleKeyDown.bind(this))
    
    // Ensure element can receive focus
    if (!this.element.hasAttribute('tabindex')) {
      this.element.setAttribute('tabindex', '0')
    }
    
    // Add role and label for screen readers
    this.element.setAttribute('role', 'group')
    this.element.setAttribute('aria-label', `${this.counterTypeValue} counter controls. Current value: ${this.currentValueValue}. Use + and - keys or arrow keys to adjust.`)
  }

  handleKeyDown(event) {
    switch(event.key) {
      case '+':
      case '=':
      case 'ArrowUp':
      case 'ArrowRight':
        event.preventDefault()
        this.increment()
        break
      case '-':
      case '_':
      case 'ArrowDown':
      case 'ArrowLeft':
        event.preventDefault()
        this.decrement()
        break
      case 'Home':
        event.preventDefault()
        this.announceShortcuts()
        break
      case '?':
        event.preventDefault()
        this.showHelp()
        break
    }
  }

  increment() {
    if (this.hasIncrementTarget) {
      // Provide feedback before clicking
      this.announceAction('increment')
      this.incrementTarget.click()
    }
  }

  decrement() {
    if (this.hasDecrementTarget) {
      // Provide feedback before clicking
      this.announceAction('decrement')
      this.decrementTarget.click()
    }
  }

  announceAction(action) {
    const verb = action === 'increment' ? 'Increasing' : 'Decreasing'
    const message = `${verb} ${this.counterTypeValue.toLowerCase()} counter`
    
    // Create temporary announcement for screen readers
    this.announceToScreenReader(message)
  }

  announceShortcuts() {
    const shortcuts = `Keyboard shortcuts for ${this.counterTypeValue.toLowerCase()}: Plus or up arrow to increase, minus or down arrow to decrease, question mark for help`
    this.announceToScreenReader(shortcuts)
  }

  showHelp() {
    const helpText = `
      Keyboard shortcuts:
      + or ↑ : Increase counter
      - or ↓ : Decrease counter  
      Home : Announce shortcuts
      ? : Show this help
    `
    
    // Show visual help tooltip
    this.showTooltip(helpText)
    this.announceToScreenReader(`Help: ${helpText.replace(/\n/g, '. ')}`)
  }

  announceToScreenReader(message) {
    // Create a temporary live region for announcements
    const announcement = document.createElement('div')
    announcement.setAttribute('aria-live', 'polite')
    announcement.setAttribute('aria-atomic', 'true')
    announcement.className = 'sr-only'
    announcement.textContent = message
    
    document.body.appendChild(announcement)
    
    // Remove after screen reader has time to announce
    setTimeout(() => {
      document.body.removeChild(announcement)
    }, 1000)
  }

  showTooltip(text) {
    // Remove existing tooltip
    const existingTooltip = document.querySelector('.keyboard-help-tooltip')
    if (existingTooltip) {
      existingTooltip.remove()
    }

    // Create new tooltip
    const tooltip = document.createElement('div')
    tooltip.className = 'keyboard-help-tooltip fixed bg-gray-800 text-white p-3 rounded shadow-lg z-50 text-sm max-w-xs'
    tooltip.style.top = '20px'
    tooltip.style.right = '20px'
    tooltip.innerHTML = text.replace(/\n/g, '<br>')
    
    document.body.appendChild(tooltip)
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
      if (document.body.contains(tooltip)) {
        tooltip.remove()
      }
    }, 5000)
    
    // Remove on click
    tooltip.addEventListener('click', () => tooltip.remove())
  }

  // Update current value when it changes
  currentValueValueChanged() {
    if (this.element.hasAttribute('aria-label')) {
      this.element.setAttribute('aria-label', 
        `${this.counterTypeValue} counter controls. Current value: ${this.currentValueValue}. Use + and - keys or arrow keys to adjust.`)
    }
  }
}