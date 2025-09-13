import os
import sys
import requests
from pathlib import Path

def get_config_dir() -> Path:
    return Path(os.getenv("XDG_CONFIG_HOME", Path.home() / ".config")) / "ghclean"

CONFIG_DIR = get_config_dir()
KEYS_FILE = CONFIG_DIR / "keys.txt"
EXCEPTIONS_FILE = CONFIG_DIR / "exceptions.txt"
BLACKLIST_FILE = CONFIG_DIR / "blacklist.txt"

def ensure_config_dir():
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    for p in (KEYS_FILE, EXCEPTIONS_FILE, BLACKLIST_FILE):
        if not p.exists():
            p.touch()

def read_keys():
    """Return (username, token). Read env first, then keys file.
       keys.txt can be either:
         username=yourname
         token=ghp_xxx
       or two lines: first username, second token (fallback).
    """
    username = os.getenv("GHCLEAN_USERNAME")
    token = os.getenv("GITHUB_TOKEN") or os.getenv("GHCLEAN_TOKEN")

    if KEYS_FILE.exists():
        with KEYS_FILE.open() as f:
            lines = [l.strip() for l in f if l.strip() and not l.strip().startswith("#")]
        # key=value parsing
        for line in lines:
            if "=" in line:
                k, v = line.split("=", 1)
                k = k.strip().lower()
                v = v.strip()
                if k in ("username", "user"):
                    username = v
                elif k in ("token", "github_token", "personal_access_token"):
                    token = v
        # fallback: plain two-line file
        if (not username or not token) and len(lines) >= 2 and "=" not in lines[0]:
            username = username or lines[0]
            token = token or lines[1]
    return username, token

def read_list(path: Path):
    if not path.exists():
        return []
    with path.open() as f:
        return [line.strip() for line in f if line.strip() and not line.strip().startswith("#")]

ensure_config_dir()

my_username, token = read_keys()
if not my_username or not token:
    print("Missing GitHub username or token. Run: ghclean setup (or create keys at {})".format(KEYS_FILE))
    sys.exit(1)

exceptions = read_list(EXCEPTIONS_FILE)
blacklist = read_list(BLACKLIST_FILE)

base_url = f'https://api.github.com/users/{my_username}/'
headers = {"Authorization": f'token {token}'}
follow = []
unfollow = []

def get_all_users(endpoint):
    users = []
    page = 1
    while True:
        url = f"{base_url}{endpoint}?per_page=100&page={page}"
        response = requests.get(url, headers=headers)
        if response.status_code != 200:
            print(f"API Error on {endpoint} page {page}!")
            break
        data = response.json()
        if not data:
            break
        users.extend(data)
        page += 1
    return users

def get_data():
    followers = get_all_users("followers")
    following = get_all_users("following")

    follower_usernames = [follower['login'] for follower in followers]
    following_usernames = [user['login'] for user in following]

    for name in following_usernames:
        if name not in follower_usernames and name not in exceptions:
            unfollow.append(name)

    for name in follower_usernames:
        if name not in following_usernames and name not in blacklist:
            follow.append(name)

def main():
    get_data()

    if len(unfollow) > 0:
        print("\n*** Unfollowing... ***\n")
        for id in unfollow:
            unfollow_url = f"https://api.github.com/user/following/{id}"
            unfollow_response = requests.delete(unfollow_url, headers=headers)
            if unfollow_response.status_code == 204:
                print(f"Unfollowed: {id}")
            else:
                print(f"*** Failed to unfollow {id}, Status Code: {unfollow_response.status_code} ***")
    else:
        print("\nNo one to unfollow!\n")

    if len(follow) > 0:
        print("\n*** Following... ***\n")
        for id in follow:
            follow_url = f"https://api.github.com/user/following/{id}"
            follow_response = requests.put(follow_url, headers=headers)
            if follow_response.status_code == 204:
                print(f"Followed: {id}")
            else:
                print(f"*** Failed to follow {id}, Status Code: {follow_response.status_code} ***")
    else:
        print("\nNo one to follow!\n")

if __name__ == "__main__":
    main()
