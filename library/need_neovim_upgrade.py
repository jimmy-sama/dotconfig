import re
import requests
import subprocess
import sys

def get_latest_github_release():
    repo_owner = "neovim"
    repo = "neovim"

    url = f"https://api.github.com/repos/{repo_owner}/{repo}/releases/latest"
    try:
        response = requests.get(url)
    except requests.exceptions.RequestException as e:
        raise sys.exit(e)

    tag_name = response.json()["tag_name"]
    version = int(tag_name.lstrip('v').replace(".", ""))
    return version

def get_neovim_version():
    pattern = r"\d+\.\d+\.\d+"
    try:
        command_output = subprocess.check_output(["nvim", "--version"], universal_newlines=True, stderr=subprocess.STDOUT)
        output_list = command_output.split("\n")
        version = int(re.search(pattern, output_list[0]).group().replace(".", ""))
        return version
    except FileNotFoundError:
        return 0

def need_upgrade():
    release_version = get_latest_github_release()
    neovim_version = get_neovim_version()
    if release_version > neovim_version:
        print("needUpgrade")
    else:
        print("upToDate")

need_upgrade()

