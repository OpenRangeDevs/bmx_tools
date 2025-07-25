import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirmation"
export default class extends Controller {
  static values = { message: String }

  confirm(event) {
    // Prevent the default form submission
    event.preventDefault()
    
    // Get the confirmation message
    const message = this.messageValue || "Are you sure?"
    
    // Show confirmation dialog
    if (confirm(message)) {
      // If confirmed, submit the form
      event.target.form.submit()
    }
    // If cancelled, do nothing (form won't submit)
  }
}