# Ansible as a dotconfig manager

## Use the kickstart script to get all the dependencies
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jimmy-sama/dotconfig/refs/heads/main/kickstart.sh)"
```

## Execute a specific role with tags
```bash
ansible-playbook example.yml --tags "terminal,neovim"
```

## ToDo's
- [ ] split up the roles so that they only serve one purpose
- [ ] use defaults for all roles so that variables can be overwritten if needed
- [ ] call the specific roles and handle "dependencies" inside a separate playbook
