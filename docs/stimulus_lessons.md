# Stimulus Lessons and Patterns

This document compiles correct patterns and lessons learned from debugging Stimulus controller issues in the Hopkinson aircraft inventory application.

## Event Flow Architecture

### Core Principle: Parent Coordinates, Children Communicate

**Rule**: Parent controllers should orchestrate interactions between multiple components. Child components should emit custom events to communicate state changes upward.

### ✅ CORRECT: Manufacturer-Model Filter Pattern

```erb
<!-- Parent controller listens for custom events and coordinates -->
<div data-controller="manufacturer-model-filter"
     data-action="manufacturer:selected->manufacturer-model-filter#manufacturerChanged">
  
  <!-- Child component emits custom events -->
  <div data-manufacturer-model-filter-target="manufacturerInput">
    <%= render DropdownComponent.new(
          form: @form,
          field: :manufacturer,
          trigger_event: "manufacturer:selected"  # Key: custom event emission
        ) %>
  </div>
  
  <!-- Sibling component gets updated by parent controller -->
  <div data-manufacturer-model-filter-target="modelDropdown">
    <%= render DropdownComponent.new(
          form: @form,
          field: :model
        ) %>
  </div>
</div>
```

**What makes this work:**
1. `data-action` on parent controller div
2. `trigger_event` parameter tells DropdownComponent to emit custom event
3. Parent controller can update both manufacturer and model dropdowns
4. Loose coupling between components

### ❌ WRONG: Child-Level Event Handling

```erb
<!-- BAD: Action listener on child element -->
<div data-controller="manufacturer-model-filter">
  <div data-manufacturer-model-filter-target="manufacturerInput"
       data-action="change->manufacturer-model-filter#manufacturerChanged">
    <%= render DropdownComponent.new(
          form: @form,
          field: :manufacturer
          # Missing: trigger_event parameter
        ) %>
  </div>
</div>
```

**Why this fails:**
1. `data-action` on child element limits scope
2. No `trigger_event` means no custom event emission
3. Parent controller can't coordinate between siblings
4. Tight coupling to DOM events instead of application events

## Custom Events vs DOM Events

### Use Custom Events for Component Communication

**✅ CORRECT**: `manufacturer:selected` (custom event)
- Can carry application-specific data
- Bubbles properly through component hierarchy
- Enables loose coupling
- Semantic meaning for the application

**❌ WRONG**: `change` (DOM event)
- Limited to basic DOM data
- Tied to specific HTML elements
- Creates tight coupling
- Generic, no application meaning

## Data Flow Patterns

### Bidirectional Communication

```
Parent Controller
    ↑ Events (custom)     ↓ Data (targets/values)
Child Components  ←→  Child Components
```

**Events flow UP**: Children notify parents of state changes
**Data flows DOWN**: Parents update children via targets and values

## Common Bug Patterns to Avoid

### 1. Missing trigger_event Parameter

```erb
<!-- BUG: Component won't emit custom events -->
<%= render DropdownComponent.new(
      field: :manufacturer
      # Missing: trigger_event: "manufacturer:selected"
    ) %>
```

### 2. data-action on Wrong Element

```erb
<!-- BUG: Should be on parent controller -->
<div data-controller="parent">
  <div data-action="custom:event->parent#handler">  <!-- WRONG LOCATION -->
    <!-- child content -->
  </div>
</div>

<!-- CORRECT: -->
<div data-controller="parent" 
     data-action="custom:event->parent#handler">  <!-- RIGHT LOCATION -->
  <div>
    <!-- child content -->
  </div>
</div>
```

### 3. Using DOM Events for App Logic

```erb
<!-- BUG: Generic DOM event -->
<div data-action="change->controller#handler">

<!-- BETTER: Semantic custom event -->
<div data-action="manufacturer:selected->controller#handler">
```

## Debugging Checklist

When a Stimulus interaction isn't working:

1. **Event Flow**: Can the event reach its handler?
   - Check `data-action` placement (should be on parent controller)
   - Verify custom event name matches in both emission and listening
   - Ensure `trigger_event` parameter is provided to components

2. **Target Access**: Can the controller find its targets?
   - Verify `data-controller` attribute is present
   - Check `data-[controller]-target` attributes are correct
   - Ensure target names match controller expectations

3. **Component Parameters**: Are all required parameters provided?
   - `trigger_event` for components that need to emit events
   - `form`, `field`, and other required component parameters

4. **Event Names**: Are custom events consistently named?
   - Use semantic names like `manufacturer:selected`
   - Avoid generic names like `change` or `update`

## Real Bug Example: Manufacturer-Model Filter

**The Bug**: Selecting a manufacturer didn't update the model dropdown options.

**Root Cause**: Event delegation was broken
- `data-action` was on child div instead of parent controller
- Missing `trigger_event` parameter prevented custom event emission

**The Fix**: 
1. Moved `data-action` to parent controller div
2. Added `trigger_event: "manufacturer:selected"` to DropdownComponent
3. Ensured proper event flow: manufacturer selection → custom event → parent handler → model update

**Lesson**: Always trace the complete event flow from user action to final DOM update.

## Future Pattern Documentation

As we encounter more Stimulus patterns and bugs, add them here with:
1. **Context**: What user interaction should happen
2. **Correct Pattern**: Working code example
3. **Common Mistakes**: What goes wrong and why
4. **Debugging Steps**: How to identify and fix the issue

This builds our knowledge base for reliable Stimulus architecture.