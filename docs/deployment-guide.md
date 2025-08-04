# BMX Race Tracker - Deployment Guide

**Version**: Alpha 1.0  
**Last Updated**: August 4, 2025

## Table of Contents
1. [Overview](#overview)
2. [System Requirements](#system-requirements)
3. [Quick Start Deployment](#quick-start-deployment)
4. [Environment Configuration](#environment-configuration)
5. [Database Setup](#database-setup)
6. [SSL & Domain Configuration](#ssl--domain-configuration)
7. [Health Checks & Monitoring](#health-checks--monitoring)
8. [Troubleshooting](#troubleshooting)

---

## Overview

This guide provides simple deployment instructions for the BMX Race Tracker alpha version. The application is designed for easy deployment with minimal infrastructure requirements.

### Architecture Overview
- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite3 (file-based, no separate DB server needed)
- **Frontend**: Hotwire (Turbo + Stimulus) with TailwindCSS
- **Real-time**: ActionCable WebSockets
- **PWA**: Service Worker for offline capability

### Deployment Options
- ✅ **Heroku** (recommended for alpha)
- ✅ **DigitalOcean App Platform**
- ✅ **Railway**
- ✅ **Traditional VPS** (Ubuntu/CentOS)
- ✅ **Docker** containers

---

## System Requirements

### Minimum Requirements
- **Ruby**: 3.3.0 or higher
- **Node.js**: 18+ (for asset compilation)
- **RAM**: 512MB minimum, 1GB recommended
- **Storage**: 1GB available space
- **OS**: Linux, macOS, or Windows with WSL

### Production Recommendations
- **RAM**: 2GB+ for better performance
- **CPU**: 2+ cores for concurrent users
- **Storage**: SSD preferred for database performance
- **SSL Certificate**: Required for WebSocket connections
- **CDN**: Optional but recommended for asset delivery

---

## Quick Start Deployment

### Option 1: Heroku Deployment (Recommended)

**Prerequisites**: Heroku CLI installed and account created

1. **Clone and prepare repository**:
   ```bash
   git clone https://github.com/OpenRangeDevs/bmx_tools.git
   cd bmx_tools
   ```

2. **Create Heroku app**:
   ```bash
   heroku create your-bmx-tracker-name
   ```

3. **Set environment variables**:
   ```bash
   heroku config:set RAILS_ENV=production
   heroku config:set SECRET_KEY_BASE=$(rails secret)
   heroku config:set ADMIN_PASSWORD=your-secure-admin-password
   ```

4. **Deploy application**:
   ```bash
   git push heroku main
   ```

5. **Run database migrations**:
   ```bash
   heroku run rails db:migrate
   heroku run rails db:seed
   ```

6. **Configure custom domain** (optional):
   ```bash
   heroku domains:add bmxtools.yourdomain.com
   heroku certs:auto:enable
   ```

### Option 2: DigitalOcean App Platform

1. **Connect your repository** via DigitalOcean dashboard
2. **Configure build settings**:
   - Build Command: `bundle install && rails assets:precompile`
   - Run Command: `rails server -p $PORT`
3. **Set environment variables** (see [Environment Configuration](#environment-configuration))
4. **Deploy** and configure domain

### Option 3: Railway

1. **Connect repository** at railway.app
2. **Set environment variables**
3. **Deploy automatically** on git push
4. **Configure custom domain** in Railway dashboard

---

## Environment Configuration

### Required Environment Variables

```bash
# Production Environment
RAILS_ENV=production

# Security (REQUIRED)
SECRET_KEY_BASE=your-generated-secret-key-here
ADMIN_PASSWORD=your-secure-admin-password

# Database (SQLite - no additional config needed)
# SQLite database file will be created at storage/production.sqlite3

# Optional: Custom Domain
ALLOWED_HOSTS=your-domain.com,www.your-domain.com

# Optional: ActionCable (for custom Redis)
# REDIS_URL=redis://localhost:6379/0  # Only if using Redis instead of default
```

### Generating SECRET_KEY_BASE

```bash
# Generate a secure secret key
rails secret

# Or use openssl
openssl rand -hex 64
```

### Admin Password Security

⚠️ **Important**: Use a strong admin password

```bash
# Good password examples (use a password manager):
ADMIN_PASSWORD=BMX2025!SecureRacing#
ADMIN_PASSWORD=TrackOfficial$2025#Safe
```

### Optional Configuration

```bash
# Timezone (defaults to system timezone)
TZ=America/Denver

# Log Level (default: info)
RAILS_LOG_LEVEL=info

# Force SSL (recommended for production)
FORCE_SSL=true

# Asset host (if using CDN)
ASSET_HOST=https://your-cdn.com
```

---

## Database Setup

### SQLite Configuration (Default)

The application uses SQLite by default - no separate database server required.

**Advantages**:
- ✅ **Zero configuration** required
- ✅ **No separate database server** to manage
- ✅ **Perfect for alpha testing** with moderate traffic
- ✅ **Automatic backups** via file system
- ✅ **Fast performance** for read-heavy workloads

**Database file location**:
```
storage/production.sqlite3    # Main database
storage/production.sqlite3-wal  # Write-ahead log
storage/production.sqlite3-shm  # Shared memory
```

### Database Migrations

```bash
# Run database migrations
rails db:migrate RAILS_ENV=production

# Seed initial data (creates sample clubs)
rails db:seed RAILS_ENV=production

# Check database status
rails db:version RAILS_ENV=production
```

### Backup Strategy

**Automated backups** (recommended):
```bash
#!/bin/bash
# backup-database.sh
DATE=$(date +%Y%m%d_%H%M%S)
cp storage/production.sqlite3 backups/bmx_tracker_$DATE.sqlite3
# Keep last 30 days
find backups/ -name "bmx_tracker_*.sqlite3" -mtime +30 -delete
```

**Manual backup**:
```bash
# Create backup
cp storage/production.sqlite3 bmx_tracker_backup.sqlite3

# Restore from backup
cp bmx_tracker_backup.sqlite3 storage/production.sqlite3
```

---

## SSL & Domain Configuration

### SSL Certificate (Required)

Most platforms provide automatic SSL:

**Heroku**:
```bash
heroku certs:auto:enable
```

**DigitalOcean**: SSL enabled by default for custom domains

**Railway**: Automatic SSL for all deployments

### Custom Domain Setup

1. **Configure DNS** to point to your deployment platform
2. **Add domain** in platform dashboard
3. **Verify SSL certificate** is active
4. **Update environment variables** if needed

### Example DNS Configuration

```
# For bmxtools.com pointing to Heroku
Type: CNAME
Name: bmxtools
Value: your-app-name.herokuapp.com

# For root domain (if supported)
Type: ALIAS or ANAME
Name: @
Value: your-app-name.herokuapp.com
```

---

## Health Checks & Monitoring

### Built-in Health Check

The application includes a health check endpoint:

```
GET /up
```

**Returns**:
- `200 OK`: Application is healthy
- `500 Error`: Application has issues

### Basic Monitoring Setup

**Platform monitoring** (automatic):
- ✅ **Heroku**: Built-in metrics and logging
- ✅ **DigitalOcean**: App monitoring dashboard  
- ✅ **Railway**: Deployment and performance metrics

**Custom monitoring** (optional):
```bash
# Simple uptime check
curl -f https://your-domain.com/up || echo "BMX Tracker is down!"

# Database check
rails runner "Club.count" RAILS_ENV=production
```

### Log Monitoring

**View logs**:
```bash
# Heroku
heroku logs --tail

# DigitalOcean
doctl apps logs your-app-id

# Local/VPS
tail -f log/production.log
```

**Key log indicators**:
- ✅ **Successful requests**: `Status: 200`
- ⚠️ **Errors**: `Status: 500` or `ERROR` messages
- ✅ **WebSocket connections**: `ActionCable` messages
- ✅ **Database operations**: SQL query logs

---

## Troubleshooting

### Common Deployment Issues

#### "Application Error" or 500 Errors

**Check logs first**:
```bash
heroku logs --tail  # or platform equivalent
```

**Common causes**:
1. **Missing SECRET_KEY_BASE**: Set environment variable
2. **Database not migrated**: Run `rails db:migrate`
3. **Asset compilation failed**: Check Node.js version
4. **Memory issues**: Upgrade to larger dyno/instance

#### WebSocket/ActionCable Issues

**Symptoms**: Real-time updates not working

**Solutions**:
1. **Verify SSL is enabled**: WebSockets require HTTPS in production
2. **Check browser console**: Look for WebSocket connection errors
3. **Test connection**: Visit `/cable` endpoint directly
4. **Verify environment**: Ensure `RAILS_ENV=production`

#### "Club not found" Errors

**Cause**: No clubs in database

**Solution**:
```bash
# Run database seeder
rails db:seed RAILS_ENV=production

# Or create clubs manually via Rails console
rails console RAILS_ENV=production
> Club.create!(name: "Your BMX Club", slug: "your-bmx-club")
```

### Performance Issues

#### Slow Page Loads

**Quick fixes**:
1. **Enable asset compression**: Should be automatic in production
2. **Check database performance**: SQLite should be fast for reads
3. **Verify SSL/TLS**: Slow SSL handshakes can impact performance
4. **Monitor resource usage**: Upgrade if CPU/memory constrained

#### High Memory Usage

**Rails memory optimization**:
```bash
# Add to production environment config
export MALLOC_ARENA_MAX=2
export RUBY_GC_HEAP_GROWTH_FACTOR=1.1
```

### Platform-Specific Issues

#### Heroku

**Common issues**:
- **Dyno sleeping**: Use hobby dyno or higher to prevent sleep
- **Database size**: Monitor SQLite file size vs. slug size limits
- **Timeout errors**: Increase timeout if needed

#### DigitalOcean App Platform

**Common issues**:
- **Build failures**: Ensure Node.js and Ruby versions are specified
- **Environment variables**: Double-check all required vars are set

### Getting Help

**Debug information to collect**:
1. **Platform logs**: Full error logs from your deployment platform
2. **Environment check**: Verify all required environment variables
3. **Health check**: Test `/up` endpoint response
4. **Browser console**: Any JavaScript errors
5. **Database status**: Verify migrations and seed data

**Useful commands**:
```bash
# Check application status
curl -I https://your-domain.com/up

# Test a specific club URL
curl https://your-domain.com/your-club-name

# Check environment variables (without showing values)
heroku config --app your-app-name | grep -v "=>"
```

---

## Production Checklist

### Pre-Deployment
- [ ] **Environment variables set**: SECRET_KEY_BASE, ADMIN_PASSWORD
- [ ] **Database migrations ready**: `rails db:migrate:status`
- [ ] **Assets precompiled**: `rails assets:precompile`
- [ ] **Tests passing**: All 47 tests pass
- [ ] **SSL certificate configured**: HTTPS enabled

### Post-Deployment
- [ ] **Health check passes**: `/up` returns 200
- [ ] **Database seeded**: At least one club exists
- [ ] **Admin login works**: Can access `/club-name/admin`
- [ ] **Real-time updates working**: Counter changes appear instantly
- [ ] **Mobile responsive**: Test on actual mobile devices
- [ ] **PWA features working**: Service worker loads correctly

### Ongoing Maintenance
- [ ] **Monitor logs**: Check for errors regularly
- [ ] **Database backups**: Automated backup strategy in place
- [ ] **SSL certificate renewal**: Usually automatic
- [ ] **Application updates**: Plan for future updates
- [ ] **Performance monitoring**: Track response times and uptime

---

*This deployment guide is designed for the alpha version of BMX Race Tracker. For production deployments serving high traffic, consider additional infrastructure like PostgreSQL, Redis, and load balancing.*