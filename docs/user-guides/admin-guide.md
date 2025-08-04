# BMX Race Tracker - Admin Guide

**Version**: Alpha 1.0  
**Last Updated**: August 4, 2025

## Table of Contents
1. [Getting Started](#getting-started)
2. [Admin Login](#admin-login) 
3. [Managing Race Counters](#managing-race-counters)
4. [Setting Race Times](#setting-race-times)
5. [Resetting Races](#resetting-races)
6. [Live Activity Monitoring](#live-activity-monitoring)
7. [Troubleshooting](#troubleshooting)

---

## Getting Started

The BMX Race Tracker admin interface allows race officials to manage race day operations with real-time counter updates that are instantly visible to spectators and riders.

### What You Can Do
- ✅ **Manage Race Counters**: Update "At Gate" and "In Staging" moto numbers
- ✅ **Set Race Times**: Configure registration deadlines and race start times
- ✅ **Reset Operations**: Reset counters and start fresh races
- ✅ **Monitor Activity**: View live activity feed of all race operations
- ✅ **Real-time Updates**: All changes broadcast instantly to public displays

### Requirements
- Web browser (Chrome, Safari, Firefox, or Edge)
- Internet connection
- Admin password for your BMX club

---

## Admin Login

### Accessing Admin Interface

1. **Navigate to your club's admin URL**:
   ```
   https://bmxtools.com/[your-club-name]/admin
   ```
   *Example: `https://bmxtools.com/calgary-bmx/admin`*

2. **Enter admin password** when prompted
3. **Click "Login"** to access race controls

### Security Features
- ✅ **4-hour session timeout** for security
- ✅ **Secure password protection** per club
- ✅ **Session management** with automatic logout
- ✅ **CSRF protection** on all admin actions

> **💡 Tip**: Bookmark your club's admin URL for quick access on race day

---

## Managing Race Counters

The core feature of the BMX Race Tracker is managing the dual counter system that shows race progression.

### Understanding the Counters

**🏁 At Gate Counter (Red)**
- Shows which moto is currently racing
- Visible to everyone as large red number
- Cannot exceed "In Staging" counter (business rule)

**🟠 In Staging Counter (Orange)**  
- Shows which moto should be in the staging area
- Visible to everyone as large orange number
- Must be greater than or equal to "At Gate" counter

### Updating Counters

#### Method 1: Individual Counter Buttons
1. **Navigate to admin interface** (see [Admin Login](#admin-login))
2. **Locate the counter sections** with large numbers and control buttons
3. **Use +1/-1 buttons** to increment or decrement each counter
4. **Changes are instant** - no save button needed

#### Method 2: Quick Reset Options
- **0 / 5**: Reset to At Gate=0, In Staging=5
- **0 / 10**: Reset to At Gate=0, In Staging=10  
- **0 / 15**: Reset to At Gate=0, In Staging=15
- **0 / 20**: Reset to At Gate=0, In Staging=20

### Business Rules (Automatic Validation)

⚠️ **Important**: The system enforces these rules automatically:

1. **At Gate** must be **less than** In Staging
2. **Both counters** must be **0 or greater**
3. **Invalid updates** are rejected with error messages
4. **All changes** are logged in the activity feed

### Example Race Day Flow

```
Race Start:     At Gate: 0,  In Staging: 5
First Moto:     At Gate: 1,  In Staging: 5  
Second Moto:    At Gate: 2,  In Staging: 6
Third Moto:     At Gate: 3,  In Staging: 7
... and so on
```

---

## Setting Race Times

Configure registration deadlines and race start times that display to all spectators with live countdown timers.

### How to Update Race Times

1. **Locate "Race Time Settings"** section in admin interface
2. **Set Race Date** using the date picker
3. **Configure Registration Time**:
   - Select hour (24-hour format)
   - Select minute
4. **Configure Race Start Time**:
   - Select hour (24-hour format) 
   - Select minute
5. **Click "Update Race Times"** to save

### Time Display Features

**For Spectators**:
- ✅ **Live countdown timers** show time remaining
- ✅ **Automatic status updates** (Open → Closed → Racing)
- ✅ **Timezone-aware** display in club's local time
- ✅ **Mobile-optimized** for easy viewing

**Admin Benefits**: 
- ✅ **Instant updates** to all connected users
- ✅ **No page refresh needed** - changes appear immediately
- ✅ **Activity logging** of all time changes

### Example Time Configuration

```
Race Date: August 15, 2025
Registration Deadline: 6:00 PM (18:00)
Race Start Time: 7:00 PM (19:00)
```

This will show spectators:
- "Registration closes in 2h 15m" (countdown)  
- "Racing begins in 3h 15m" (countdown)

---

## Resetting Races

Reset functionality allows you to start fresh races or return to common starting points.

### Reset Race (Recommended)

**🏁 Reset Race** - Complete race reset with updated times:

1. **Click "🔄 Reset Race"** in the green section
2. **Confirm the action** when prompted
3. **Automatic updates**:
   - Counters reset to: At Gate=0, In Staging=0
   - Registration time set to: 1 hour from now
   - Race start time set to: 3 hours from now

### Reset Counters Only

⚠️ **Use with caution** - these operations cannot be undone:

**Individual Resets**:
- **Reset At Gate**: Sets At Gate to 0, keeps In Staging unchanged
- **Reset In Staging**: Sets both counters to 0 (business rule)
- **Reset All**: Sets both counters to 0

**Quick Reset Options**: Set to common starting combinations (0/5, 0/10, etc.)

### When to Use Reset Functions

✅ **Good times to reset**:
- Starting a new race day
- After technical difficulties
- Beginning practice sessions
- Between different race categories

❌ **Avoid resetting during**:
- Active racing when spectators are watching
- Mid-race when motos are in progress

---

## Live Activity Monitoring

The admin interface provides real-time monitoring of all race operations.

### Activity Feed Features

**📡 Live Activity Feed** shows:
- ✅ **Counter updates** with before/after values
- ✅ **Race time changes** with timestamps
- ✅ **Reset operations** and their details
- ✅ **Connection status** (online/offline)
- ✅ **Recent activity count** (last 10 actions)

### Reading Activity Entries

```
📊 Counters updated: At Gate 2→3, In Staging 5→6
⏰ Race times updated: Registration deadline changed
🔄 Race reset: Counters reset to 0,0 with new times
```

### Connection Status

**Green indicators**:
- ✅ **"📡 Connected to live feed"** - Real-time updates active
- ✅ **Connection count** shows number of recent activities

**Troubleshooting indicators**:
- ⚠️ **Connection issues** will show in the status area
- 🔄 **Automatic reconnection** attempts in progress

---

## Troubleshooting

### Common Issues and Solutions

#### "At gate must be less than staging counter" Error

**Problem**: Trying to set At Gate ≥ In Staging  
**Solution**: 
1. Increase In Staging counter first
2. Then adjust At Gate counter
3. Or use Quick Reset options

#### Changes Not Appearing on Public Display

**Problem**: Updates not visible to spectators  
**Solution**:
1. Check connection status in activity feed
2. Refresh the admin page (Ctrl+F5)
3. Verify spectators are on correct club URL
4. Check internet connection

#### Session Expired Message

**Problem**: "Your session has expired" error  
**Solution**:
1. Re-enter admin password
2. Session automatically times out after 4 hours
3. This is a security feature

#### Page Showing Old Counter Values

**Problem**: Admin page shows 0,0 after browser refresh  
**Solution**:
1. **Hard refresh**: Ctrl+Shift+R (PC) or Cmd+Shift+R (Mac)
2. This clears cached data and loads fresh values
3. Regular refresh (F5) may show cached data

### Mobile Usage Tips

✅ **For best mobile experience**:
- Use landscape orientation for easier button access
- Ensure strong internet connection
- Buttons are optimized for touch (44px minimum)
- Haptic feedback on supported devices

### Getting Help

**Quick Checks**:
1. ✅ Internet connection working?
2. ✅ Using correct club URL?
3. ✅ Admin password correct?
4. ✅ Recent browser (Chrome, Safari, Firefox, Edge)?

**Contact Information**: 
- Technical issues: Check deployment documentation
- Feature requests: Note for post-alpha feedback

---

## Best Practices

### Race Day Setup

1. **Before riders arrive**:
   - Test admin login and counter updates
   - Set registration and race start times
   - Reset counters to starting position (0/5 or 0/10)

2. **During race operations**:
   - Update counters as motos progress
   - Monitor activity feed for issues
   - Use Quick Reset between race categories

3. **End of day**:
   - Leave counters showing final results
   - No need to reset unless starting new event

### Security Best Practices

- ✅ **Don't share admin password** publicly
- ✅ **Log out when finished** or rely on 4-hour timeout
- ✅ **Use HTTPS** (automatically enforced)
- ✅ **Keep browser updated** for security

---

*This guide covers the alpha version of BMX Race Tracker. Features and interface may be updated based on user feedback and testing.*