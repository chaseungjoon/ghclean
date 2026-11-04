# `ghclean` - Automatic follower/following manager script for Github

### A CLI tool to automatically manage your GitHub followers and following lists.

---

## Features

 1) **Automatic cleanup** -  Unfollow users who don't follow you back

 2) **Auto-follow** - Follow back users who follow you

 3) **Exceptions list** - Maintain a list of users you always want to follow
 
 4) **Blacklist** - Maintain a list of users you never want to follow

 5) **Auto mode** - Blacklist users who unfollowed you or can't be followed

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

### 2. Run the cleanup in `auto` mode

```bash
ghclean run --auto
```

- Runs `ghclean run` twice (only once if the first run has no one to follow)
- Adds users I unfollowed to `blacklist`
- Adds users who can't be followed to `blacklist` (they show up under `Following...` again on the second run)
- Lists them under `Added to blacklist` at the end

To use `auto` mode by default (`ghclean default manual` turns it off):

```bash
ghclean default auto
```

### 3. Add usernames to `exceptions` - users you always want to follow

```bash
ghclean -e username1 username2 username3 ...
```

### 4. Add usernames to `blacklist` - users you never want to follow

```bash
ghclean -b spammer1 spammer2 spammer3 ...
```

### 5. View your current `exceptions`, `blacklist`

```bash
ghclean view
```

### 6. Export `exceptions`, `blacklist`

```bash
ghclean export --exceptions   # exceptions only
ghclean export --blacklist    # blacklist only
ghclean export --all          # both
```

- Saves `ghclean-exceptions.txt` and/or `ghclean-blacklist.txt` to `~/Downloads`
- Use `--path` to save them somewhere else: `ghclean export --all --path=/home/user/backup`
- To use them on another computer, copy them to `~/.config/ghclean/` as `exceptions.txt` and `blacklist.txt`

### 7. Get help

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
- `default.txt`: Default mode for `ghclean run` (`auto` or `manual`)

