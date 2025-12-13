#!/bin/bash

echo "Performing update..."

# Run ansible playbook
PYTHON_SITE_PACKAGES=`python -c 'import site; print(site.getsitepackages()[0])'`
export ANSIBLE_COLLECTIONS_PATH=$PYTHON_SITE_PACKAGES/ansible_collections
.venv/bin/ansible-playbook playbook.yml

echo "Update completed!"
