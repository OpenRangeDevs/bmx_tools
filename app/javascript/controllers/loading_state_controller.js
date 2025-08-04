import { Controller } from "@hotwired/stimulus"

// Loading State Controller
// Manages loading states and skeleton screens for async operations
export default class extends Controller {
  static targets = ["skeleton", "content", "spinner"]
  static classes = ["loading", "hidden"]

  connect() {
    // Initially show content, hide skeleton
    this.showContent()
  }

  // Show loading state with skeleton screen
  showLoading() {
    if (this.hasSkeletonTarget) {
      this.skeletonTarget.classList.remove(this.hiddenClass)
    }
    
    if (this.hasContentTarget) {
      this.contentTarget.classList.add(this.hiddenClass)
    }
    
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove(this.hiddenClass)
    }
    
    // Add loading class to root element
    this.element.classList.add(this.loadingClass)
  }

  // Show content, hide skeleton/loading states
  showContent() {
    if (this.hasSkeletonTarget) {
      this.skeletonTarget.classList.add(this.hiddenClass)
    }
    
    if (this.hasContentTarget) {
      this.contentTarget.classList.remove(this.hiddenClass)
    }
    
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add(this.hiddenClass)
    }
    
    // Remove loading class from root element
    this.element.classList.remove(this.loadingClass)
  }

  // Action to toggle loading state
  toggleLoading() {
    if (this.element.classList.contains(this.loadingClass)) {
      this.showContent()
    } else {
      this.showLoading()
    }
  }

  // Automatically show loading for form submissions
  handleFormSubmit() {
    this.showLoading()
    
    // Auto-hide loading after 5 seconds as fallback
    setTimeout(() => {
      this.showContent()
    }, 5000)
  }

  // Handle Turbo events for automatic loading states
  handleTurboSubmitStart() {
    this.showLoading()
  }

  handleTurboSubmitEnd() {
    this.showContent()
  }

  handleTurboFrameLoad() {
    this.showContent()
  }
}