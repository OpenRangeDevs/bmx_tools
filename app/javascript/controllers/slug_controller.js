import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slug"
export default class extends Controller {
  static targets = ["name", "slug", "preview"]

  connect() {
    this.updatePreview()
  }

  updateSlug() {
    // Only auto-generate if slug field is empty
    if (!this.slugTarget.value && this.nameTarget.value) {
      const slug = this.generateSlug(this.nameTarget.value)
      this.slugTarget.value = slug
      this.updatePreview()
    }
  }

  updatePreview() {
    const slug = this.slugTarget.value || 'your-club-slug'
    this.previewTarget.textContent = slug
  }

  generateSlug(name) {
    return name.toLowerCase()
               .replace(/[^a-z0-9\s-]/g, '')
               .replace(/\s+/g, '-')
               .replace(/-+/g, '-')
               .replace(/^-|-$/g, '')
  }
}