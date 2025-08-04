# BMX Race Tracker - Spectator & Rider Guide

**Version**: Alpha 1.0  
**Last Updated**: August 4, 2025

## Table of Contents
1. [Getting Started](#getting-started)
2. [Understanding the Display](#understanding-the-display)
3. [Reading Race Progress](#reading-race-progress)
4. [Race Times & Countdown](#race-times--countdown)
5. [Mobile Usage](#mobile-usage)
6. [Frequently Asked Questions](#frequently-asked-questions)

---

## Getting Started

The BMX Race Tracker provides real-time race information for spectators, riders, and families. See live updates of race progress, registration deadlines, and race start times.

### What You Can See
- ✅ **Live Race Progress**: Current moto at gate and in staging
- ✅ **Real-time Updates**: Automatic updates as race officials make changes
- ✅ **Race Times**: Registration deadlines and race start times with countdowns
- ✅ **Mobile Optimized**: Perfect viewing on phones and tablets
- ✅ **Always Current**: No need to refresh - updates appear instantly

### How to Access

**Visit your BMX club's URL**:
```
https://bmxtools.com/[your-club-name]
```

**Examples**:
- Calgary BMX: `https://bmxtools.com/calgary-bmx`
- Edmonton BMX: `https://bmxtools.com/edmonton-bmx`
- Red Deer BMX: `https://bmxtools.com/red-deer-bmx`

> **💡 Tip**: Bookmark your club's URL for quick access on race days

---

## Understanding the Display

The race tracker shows two main counters that track race progression:

### 🏁 At Gate Counter (Red)
```
┌─────────────────┐
│   🏁 At Gate    │
│        3        │
│ Moto 3 is currently racing │
└─────────────────┘
```

**What it means**:
- Shows which moto is **currently racing**
- Large red number is easy to see from distance
- Updates in real-time as motos finish
- "0" means racing hasn't started yet

### 🟠 In Staging Counter (Orange)
```
┌─────────────────┐
│  🟠 In Staging   │
│        5        │
│ Moto 5 should be in staging area │
└─────────────────┘
```

**What it means**:
- Shows which moto should be **preparing to race**
- Large orange number for easy visibility
- Usually 1-3 motos ahead of "At Gate"
- Gives riders time to prepare

### How They Work Together

**Example Race Progression**:
```
Start:    At Gate: 0   In Staging: 5
          "No racing yet, Moto 5 prepare"

Active:   At Gate: 2   In Staging: 5  
          "Moto 2 racing, Moto 5 staging"

Later:    At Gate: 4   In Staging: 7
          "Moto 4 racing, Moto 7 staging"
```

---

## Reading Race Progress

### Race Status Messages

The display shows helpful status messages based on the counters:

**🏁 At Gate Messages**:
- `Racing hasn't started yet` (when counter = 0)
- `Moto 3 is currently racing` (when counter = 3)

**🟠 In Staging Messages**:
- `No motos staging yet` (when counter = 0)  
- `Moto 5 should be in staging area` (when counter = 5)

### What Each Status Means

**For Riders**:
- ✅ **Your moto number ≤ In Staging**: Get ready to stage soon
- ✅ **Your moto number = At Gate**: You're racing right now!
- ✅ **Your moto number > In Staging**: Wait for your turn

**For Spectators**:
- ✅ **Follow race progression** as numbers increase
- ✅ **Know when favorite riders** are up next
- ✅ **Plan timing** for watching specific motos

### Example: Following Moto 8

```
Current Display: At Gate: 5, In Staging: 7
Status: "Moto 8 riders should start heading to staging area"

Next Update: At Gate: 6, In Staging: 8  
Status: "Moto 8 is now in staging, get ready to race!"

Then: At Gate: 8, In Staging: 10
Status: "Moto 8 is currently racing!"
```

---

## Race Times & Countdown

### Registration Deadline

```
┌─────────────────────────────┐
│ 📝 Registration Deadline    │
│        6:30 PM              │
│   ⏰ 1h 23m remaining      │
│   Registration Open         │
└─────────────────────────────┘
```

**What you see**:
- **Deadline time** in easy-to-read format
- **Live countdown** showing time remaining
- **Status indicator**: Open → Closed
- **Automatic updates** as time passes

### Race Start Time

```
┌─────────────────────────────┐
│   🏁 Race Start Time        │
│        7:00 PM              │
│   🏁 2h 15m until racing    │
│      Racing begins soon     │
└─────────────────────────────┘
```

**Status Messages**:
- `Registration Open` → `Registration Closed` → `Racing has begun!`
- Live countdown shows exactly how much time remains
- Times automatically adjust for your local timezone

### Planning Your Race Day

**Use the countdowns to**:
- ✅ **Plan arrival time** based on registration deadline
- ✅ **Know exactly when racing starts** 
- ✅ **Track time remaining** for warm-up and preparation
- ✅ **Stay informed** of any time changes (updates automatically)

---

## Mobile Usage

The BMX Race Tracker is designed mobile-first for optimal viewing on phones and tablets.

### Mobile Features

✅ **Large, Easy-to-Read Numbers**:
- 72px font size for counter numbers
- High contrast colors (red/orange)
- Readable from across the track

✅ **Touch-Friendly Design**:
- Optimized for all screen sizes
- No zooming required
- Portrait and landscape modes

✅ **Fast Loading**:
- Loads quickly on cellular data
- Minimal data usage
- Works on 3G connections

✅ **Battery Efficient**:
- Optimized JavaScript
- Efficient real-time updates
- Background sync when available

### Mobile Tips

**For Best Experience**:
1. **Add to Home Screen**: Bookmark for quick access
2. **Keep Connected**: Stable internet ensures real-time updates
3. **Landscape Mode**: May be easier to read on small screens
4. **Brightness Up**: Outdoor viewing in sunlight

**Data Usage**: Very minimal - mostly text updates

---

## Frequently Asked Questions

### About Real-Time Updates

**Q: How often do the numbers update?**  
A: Instantly! As soon as race officials make changes, you'll see them. No need to refresh the page.

**Q: Why don't I see changes immediately?**  
A: Check your internet connection. Updates require connectivity. The page will show connection status.

**Q: Do I need to refresh the page?**  
A: No! The page updates automatically. Refreshing may actually slow things down.

### About Race Information

**Q: What if the counters show 0, 0?**  
A: This means racing hasn't started yet, or race officials are resetting for a new event.

**Q: Can the numbers go backwards?**  
A: Yes, race officials can adjust counters if needed (corrections, practice runs, etc.).

**Q: What if race times change?**  
A: Time changes appear automatically with updated countdowns. No action needed on your part.

### Technical Questions

**Q: Which browsers work best?**  
A: Chrome, Safari, Firefox, and Edge all work great. Keep your browser updated for best performance.

**Q: Does it work offline?**  
A: The basic page can load offline, but real-time updates require internet connection.

**Q: Is my data secure?**  
A: Yes! This is a read-only display. No personal information is collected or stored.

### Troubleshooting

**Q: Page shows old information after refreshing**  
A: Try a "hard refresh":
- **PC**: Ctrl + Shift + R
- **Mac**: Cmd + Shift + R  
- **Mobile**: Close and reopen browser tab

**Q: Numbers seem stuck or not updating**  
A: Check your internet connection. If connection is good, try refreshing the page.

**Q: Can't find my club's URL**  
A: Club URLs follow the pattern: `bmxtools.com/[club-name-with-dashes]`  
Contact your club if you're unsure of the exact URL.

---

## Features for Different Users

### For Riders
- ✅ **Track your moto's progress** toward staging and gate
- ✅ **Get early warning** when it's time to prepare  
- ✅ **Stay informed** of any schedule changes
- ✅ **Plan warm-up timing** based on race progression

### For Parents & Spectators
- ✅ **Follow race progression** and know when to pay attention
- ✅ **Track favorite riders** by moto number
- ✅ **Plan arrival and departure** times based on schedule
- ✅ **Stay updated** on race times and changes

### For Track Officials (Non-Admin)
- ✅ **Monitor race progression** without admin access
- ✅ **Verify counter accuracy** from track level
- ✅ **Coordinate with admin officials** using shared display
- ✅ **Reference for announcements** and communications

---

## Getting the Most Out of Race Day

### Before You Arrive
1. **Bookmark your club's URL** on your phone
2. **Check registration deadline** and plan arrival accordingly
3. **Note race start time** for schedule planning

### At the Track  
1. **Keep the tracker open** on your phone for instant updates
2. **Share the URL** with other parents and spectators
3. **Use countdown timers** to plan concessions, parking, etc.
4. **Reference moto numbers** for tracking race progress

### Pro Tips
- ✅ **Multiple devices**: Everyone can view simultaneously
- ✅ **Share with friends**: Send them your club's URL
- ✅ **Use as reference**: Great for coordinating family activities
- ✅ **Stay connected**: Stable internet = better experience

---

*This guide covers the alpha version of BMX Race Tracker. The interface is designed to be intuitive, but don't hesitate to ask race officials if you have questions about specific race day operations.*