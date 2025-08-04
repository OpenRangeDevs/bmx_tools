import { Controller } from "@hotwired/stimulus"

// Handles separate date/time form controls and combines them into datetime values
export default class extends Controller {
  static targets = [
    "raceDate", 
    "registrationHour", "registrationMinute", "registrationDeadlineHidden",
    "raceStartHour", "raceStartMinute", "raceStartTimeHidden"
  ]

  connect() {
    // Update hidden fields when any input changes
    this.raceDateTarget.addEventListener("change", this.updateHiddenFields.bind(this))
    this.registrationHourTarget.addEventListener("change", this.updateHiddenFields.bind(this))
    this.registrationMinuteTarget.addEventListener("change", this.updateHiddenFields.bind(this))
    this.raceStartHourTarget.addEventListener("change", this.updateHiddenFields.bind(this))
    this.raceStartMinuteTarget.addEventListener("change", this.updateHiddenFields.bind(this))
    
    // Set initial values
    this.updateHiddenFields()
  }

  updateHiddenFields() {
    const date = this.raceDateTarget.value
    
    if (date) {
      // Build registration deadline datetime
      const regHour = this.registrationHourTarget.value
      const regMinute = this.registrationMinuteTarget.value
      if (regHour && regMinute) {
        const regDateTime = this.buildDateTime(date, regHour, regMinute)
        this.registrationDeadlineHiddenTarget.value = regDateTime
      }
      
      // Build race start datetime
      const startHour = this.raceStartHourTarget.value
      const startMinute = this.raceStartMinuteTarget.value
      if (startHour && startMinute) {
        const startDateTime = this.buildDateTime(date, startHour, startMinute)
        this.raceStartTimeHiddenTarget.value = startDateTime
      }
    }
  }

  buildDateTime(date, hour, minute) {
    // Format: "YYYY-MM-DDTHH:MM:SS" for Rails datetime fields
    const paddedHour = String(hour).padStart(2, '0')
    const paddedMinute = String(minute).padStart(2, '0')
    return `${date}T${paddedHour}:${paddedMinute}:00`
  }
}