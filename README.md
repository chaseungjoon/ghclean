# ghclean

A command-line tool to automatically manage your GitHub followers and following lists.

## Features

- **Automatic cleanup**: Unfollow users who don't follow you back
- **Auto-follow**: Follow users who follow you
- **Exceptions list**: Maintain a list of users you always want to follow
- **Blacklist**: Maintain a list of users you never want to follow
- **Easy management**: Simple commands to view and manage your lists

## Installation

### Via Homebrew (recommended)

```bash
brew install ghclean
```

### Manual Installation

1. Clone this repository
2. Make the script executable: `chmod +x ghclean`
3. Copy to your PATH or run locally

## Setup

Run the interactive setup to configure your GitHub credentials:

```bash
ghclean setup
```

This will:

- Install required Python dependencies
- Prompt for your GitHub username
- Prompt for your GitHub Personal Access Token (with `user:follow` permission)

## Usage

### Run the cleanup

```bash
ghclean run
```

### Manage exceptions (users you always want to follow)

```bash
ghclean -e username1 username2 username3
```

### Manage blacklist (users you never want to follow)

```bash
ghclean -b spammer1 spammer2 spammer3
```

### View your current lists

```bash
ghclean view
```

### Get help

```bash
ghclean -h
```

## Requirements

- Python 3.6+
- `requests` library (automatically installed during setup)
- GitHub Personal Access Token with `user:follow` permission

## Configuration Files

Configuration files are stored in `~/.config/ghclean/`:

- `keys.txt`: Your GitHub username and token
- `exceptions.txt`: Users you always want to follow
- `blacklist.txt`: Users you never want to follow

## License

MIT License - see LICENSE file for details.
