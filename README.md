# Entry App

A simple web application that saves user data into MongoDB. The app runs on an Ubuntu server and connects to the `mr_doe_prod` database.

## Features

- Add a new user (name, email, role) through a simple web page
- See all saved users in a table
- Delete any user
- Every user you add is saved directly into MongoDB
- MongoDB data is backed up automatically every night at 12:00 AM

## How to run

```bash
npm install
cp .env.example .env
node server.js
```

The app starts on `http://localhost:3000`.

## Project structure

```
entry-app/
├── server.js          # Express server + API routes
├── package.json       # Project dependencies
├── public/
│   └── index.html     # Frontend page
├── .env.example       # Environment variables sample
└── README.md
```

## API endpoints

| Method | URL | What it does |
|--------|-----|--------------|
| GET | `/api/users` | List all users |
| POST | `/api/users` | Add a new user |
| DELETE | `/api/users/:id` | Delete a user |
| GET | `/` | Open the web page |

## Server setup on Ubuntu

This project is deployed on an Ubuntu server with these folders:

```
/home/ubuntu/
├── entry-app/              # This web application
└── mongodb-backup/         # Automatic MongoDB backup
    ├── backups.sh          # Backup script (runs daily at 12 AM)
    ├── backup.log          # Backup log file
    └── backups_data/       # Zip files of the backups
```

### App runs as a systemd service

Service name: `entry-app`

```bash
sudo systemctl status entry-app
```

### Automatic backup

The cron job is:

```
0 0 * * * /home/ubuntu/mongodb-backup/backups.sh >> /home/ubuntu/mongodb-backup/backup.log 2>&1
```

This runs every night at exactly 12:00 AM. The backup script uses `mongodump` to copy the `mr_doe_prod` database and packs it into a `.tar.gz` zip file in `backups_data/`.

## Report of changes made

- Built this web application (Express + Mongoose) and connected it to the MongoDB `mr_doe_prod` database
- Added a crypto shim in `server.js` so the app works on Node 18 (the MongoDB driver needs the `crypto` global)
- Registered the app as a `systemd` service called `entry-app` so it always stays running
- Created a clean folder structure: `entry-app/` for the app and `mongodb-backup/` for backups
- Moved the backup script to `mongodb-backup/backups.sh` and updated its folder path
- Updated the cron job to the new backup path (runs every night at 12:00 AM)
- Deleted junk files on the server: the empty `mr_doe_prod/` folder and a stray `~` folder
- Tested everything: adding a user through the app saves it in MongoDB, and the backup script produces a zip file correctly
