default-host := 'cepheus'

# run entire playbook
run host=default-host *flags: _check-ssh-key
  ansible-playbook main.yml --limit {{host}} {{flags}}

# run plays with #compose
compose host=default-host *flags: _check-ssh-key
  ansible-playbook main.yml --tags compose --limit {{host}} {{flags}}
alias c := compose

# update compose for a specific app
compose-app host app *flags: _check-ssh-key
  ansible-playbook main.yml --tags compose --limit {{host}} --extra-vars "app={{app}}" {{flags}}
alias ca := compose-app

# Helper recipes

# waits for the ansible SSH key to be loaded
_check-ssh-key:
    #!/usr/bin/env bash
    set -euo pipefail
    
    if ! ssh-add -l 2>/dev/null | grep -q "ansible"; then
        echo "Ansible SSH key not found, please load it. I'll wait..."
        until ssh-add -l 2>/dev/null | grep -q "ansible"; do
            sleep 0.5
        done
    fi