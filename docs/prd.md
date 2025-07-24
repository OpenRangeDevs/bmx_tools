# BMX Race Tracker - Product Requirements Document

## Overview
A mobile-first web application designed to track moto (heat) progression during BMX races. The tracker allows race officials to independently manage which moto is currently at the gate and which is in staging, providing real-time information to riders, spectators, and race staff.

## Problem Statement
BMX races involve numerous riders competing in multiple motos throughout the day. Riders and spectators need to know:
- Which moto is currently racing (at the gate)
- Which riders should be preparing (in staging)
- When registration closes and when racing begins

Current manual tracking methods make it difficult to communicate this information effectively, especially in large races with 100+ riders and 200+ motos.

## Target Users
1. **Race Officials** - Update and manage moto progression
2. **Riders** - Check when they need to report to staging
3. **Spectators** - Track when specific motos will be at the gate

## Core Features

### 1. Dual Independent Counters
- **At Gate Counter**: Displays which moto is currently racing
- **In Staging Counter**: Displays which moto should be preparing to race

#### Requirements:
- Counters must operate independently
- At Gate can be 0 (before racing starts)
- Staging must always be greater than or equal to the Gate
- Large, easily readable numbers (72px font size)
- Visual distinction between counters (red border for gate, orange for staging)
- Each race is run by a separate club, which means there must be a way to access the race page of each club. e.g bmxtools.com/[club-name]
- The race page must refresh as the data changes.

### 2. Race Operator Counter Controls
Each counter must have:
- **Increment button** (+1) - Large, primary action
- **Decrement button** (-1) - Smaller size (50% of increment button)
- **Direct input field** with "GO" button for jumping to specific moto
- Input validation to maintain business rules

### 3. Race Admin Race Time Settings
- **Registration Deadline** time picker
- **Race Start Time** time picker
- Display times in 12-hour format (e.g., "10:30 AM")

### 4. Race Admin Reset Functionality
- Single "Reset All" button
- Confirmation dialog before resetting
- Resets: At Gate to 0, In Staging to 0

### 5. Race Admin Notifications
- Ability to broadcast notifications that take over page
- Notifications must be time restricted e.g. set the notification to last 30min
- Notification must be able to be minimized but not closed while active
- Must allow for limited messaging along with timer display

## Technical Requirements

### Platform
- Mobile-first responsive web application
- Optimized for smartphone usage
- No app installation required

### UI/UX Requirements
- **Touch-optimized**: Minimum 44px touch targets
- **No zoom**: Viewport locked to prevent accidental zooming
- **Vertical layout**: Stack elements for easy scrolling
- **Visual feedback**: Button press animations
- **Numeric keyboard**: Number inputs trigger numeric keyboard on mobile

### Validation Rules
1. At Gate counter:
   - Minimum value: 0
   - Must be less than Staging counter

2. In Staging counter:
   - Minimum value: 0
   - Must be greater than or equal to At Gate counter

3. Error handling:
   - Show alert for invalid input attempts
   - Clear input field after invalid attempt

### Data Persistence
- Store race times in localStorage
- Counter values should NOT persist (reset on page reload)

### Browser Support
- Modern mobile browsers (iOS Safari, Chrome Android)
- No desktop optimization required

## Visual Design

### Color Scheme
- At Gate: Red (#ff4444) border, light red (#ffeeee) background
- In Staging: Orange (#ff9944) border, light orange (#fff5ee) background
- Primary buttons: Blue (#007bff)
- Decrement buttons: Gray (#6c757d)
- Increment buttons: Green (#28a745)
- Reset button: Red (#dc3545)

### Typography
- Primary font-family: font-family: Roboto, sans-serif
- Secondary font-family: Helvetica, Arial, serif
- Counter numbers: 72px bold
- Section headers: 20px with emoji icons
- Button text: 18px (16px for decrement buttons)

### Layout
- 10px padding on container
- 15px margin between sections
- 20px padding within sections
- 8px border radius for buttons
- 12px border radius for sections

## Future Considerations
- Integration with rider tracking systems
- Push notifications for upcoming motos
- Offline functionality with service workers

## Success Metrics
- Page load time under 2 seconds on 3G
- Zero accidental counter changes (proper touch target sizing)
- 90%+ user success rate for updating counters
- Positive feedback from race officials on ease of use

## Software Requirements
- Ruby on Rails version 8+
- SQLite not postgresql
- Hotwire not react
- use minitest not rspec
- Db-backed for modern rails implementation
- No external services
