# `ghclean` - Automatic follower/following manager script for Github

### A CLI tool to automatically manage your GitHub followers and following lists.

---

## Features

 1) **Automatic cleanup** -  Unfollow users who don't follow you back

 2) **Auto-follow** - Follow back users who follow you

 3) **Exceptions list** - Maintain a list of users you always want to follow
 
 4) **Blacklist** - Maintain a list of users you never want to follow

---

# How to Use

## 1) Installation

### Via Homebrew (recommended)

```bash
brew tap chaseungjoon/ghclean
brew install ghclean
```


### Manual Installation

1. Clone this repository
2. Make the script executable: `chmod +x ghclean`
3. Copy to your PATH or run locally

---

## 2) Setup

Run the interactive setup to configure your GitHub credentials:

```bash
ghclean setup
```

This will:

- Install required Python dependencies (`requests`)
- Prompt for your GitHub username
- Prompt for your GitHub Personal Access Token (with `user:follow` permission)

---

## 3) Usage

### 1. Run the cleanup

```bash
ghclean run
```

- `Follows` back my new followers (skips users in `blacklist`)
- `Unfollows` who don't follow me back (skips users in `exceptions`)

### 2. Add usernames to `exceptions` - users you always want to follow

```bash
ghclean -e username1 username2 username3 ...
```

### 3. Add usernames to `blacklist` - users you never want to follow

```bash
ghclean -b spammer1 spammer2 spammer3 ...
```

### 4. View your current `exceptions`, `blacklist`

```bash
ghclean view
```

### 5. Get help

```bash
ghclean -h
```

---

## Requirements

- Python 3.6+ (`requests` library)
- GitHub Personal Access Token with `user:follow` permission

---

## Configuration Files

Configuration files are stored in `~/.config/ghclean/`:

- `keys.txt`: Your GitHub username and personal access token
- `exceptions.txt`: Users you always want to follow
- `blacklist.txt`: Users you never want to follow

