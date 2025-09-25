# Run LIME with Restic Docker Backup

## Overview

This documentation covers setting up automated backups for Docker Compose applications using Restic, a modern backup tool that provides fast, secure, and deduplicated backups. The setup uses the `mekomsolutions/restic-compose-backup` Docker image to automatically backup Docker containers and volumes to a local directory. See [mekomsolutions/restic-compose-backup](https://github.com/mekomsolutions/restic-compose-backup) for more details.


## Installation and Setup

### 1. Create Backup Directory

Create a dedicated directory for your backups:

```bash
# Create backup directory
sudo mkdir -p ~/backups/restic_data

# Set appropriate permissions
sudo chmod 700 ~/backups/restic_data

# Change ownership if needed
sudo chown $USER:$USER ~/backups/restic_data
```

### 2. Environment Configuration

Create a `run/docker/concatenated.env` file with your backup configuration:

```bash
# Restic Backup Configuration
BACKUP_PATH=~/backups/restic_data
RESTIC_PASSWORD=your-strong-password-here
RESTIC_KEEP_DAILY=7
RESTIC_KEEP_WEEKLY=4
RESTIC_KEEP_MONTHLY=6
RESTIC_KEEP_YEARLY=2
LOG_LEVEL=INFO
CRON_SCHEDULE=0 0 * * *
```

### 3. Start LIME

Start LIME instance with `./start.sh` or `start-with-sso.sh`

## Configuration

### Environment Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `BACKUP_PATH` | Local directory for backups | `./restic_data` | `~/backups/restic_data` |
| `RESTIC_PASSWORD` | Encryption password | *Required* | `my-secure-password-123` |
| `RESTIC_KEEP_DAILY` | Daily snapshots to retain | `7` | `14` |
| `RESTIC_KEEP_WEEKLY` | Weekly snapshots to retain | `4` | `8` |
| `RESTIC_KEEP_MONTHLY` | Monthly snapshots to retain | `6` | `12` |
| `RESTIC_KEEP_YEARLY` | Yearly snapshots to retain | `2` | `3` |
| `LOG_LEVEL` | Logging verbosity | `INFO` | `DEBUG`, `WARN`, `ERROR` |
| `CRON_SCHEDULE` | Backup schedule (cron format) | `0 0 * * *` | `0 2 * * *` (2 AM daily) |

### Cron Schedule Examples

| Schedule | Description |
|----------|-------------|
| `0 0 * * *` | Daily at midnight |
| `0 2 * * *` | Daily at 2 AM |
| `0 0 * * 0` | Weekly on Sunday at midnight |
| `0 0 1 * *` | Monthly on the 1st at midnight |
| `*/30 * * * *` | Every 30 minutes |

## Support and Resources

- [Restic Documentation](https://restic.readthedocs.io/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Cron Expression Format](https://crontab.guru/)
- [mekomsolutions/restic-compose-backup](https://github.com/mekomsolutions/restic-compose-backup)