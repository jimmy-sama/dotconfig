# Ansible as a dotconfig manager

## Use the kickstart script to get all the dependencies
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jimmy-sama/dotconfig/refs/heads/main/kickstart.sh)"
```

## Execute a specific role with tags
```bash
ansible-playbook example.yml --tags "terminal,neovim"
```
