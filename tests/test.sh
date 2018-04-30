#!/bin/bash
#
# Ansible role test shim.
#
# Usage: [OPTIONS] ./tests/test.sh
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - role_dir: the directory where the role exists (default = $PWD)
#
# If you place a requirements.yml file in tests/requirements.yml, the
# requirements listed inside that file will be installed via Ansible Galaxy
# prior to running tests.
#
# License: MIT

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)

## Set up vars for Docker setup.
distro="ubuntu1604"
init="/lib/systemd/systemd"
opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
container_id=${container_id:-$timestamp}

# Inputs
playbook=${playbook:-"test.yml"}
role_dir=${role_dir:-"$PWD"}

# Run the container using the supplied OS.
printf ${green}"Starting Docker container: geerlingguy/docker-$distro-ansible."${neutral}"\n"
docker pull geerlingguy/docker-$distro-ansible:latest
docker run --detach --volume="$role_dir":/etc/ansible/roles/role_under_test:rw --name $container_id $opts geerlingguy/docker-$distro-ansible:latest $init

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
docker exec --tty $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: docker exec $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook"${neutral}
docker exec $container_id env TERM=xterm env ANSIBLE_FORCE_COLOR=1 ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook

# Run Ansible playbook again (idempotence test).
printf ${green}"Running playbook again: idempotence test"${neutral}
idempotence=$(mktemp)
docker exec $container_id ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook | tee -a $idempotence
tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)

# Remove the Docker container
printf "Removing Docker container...\n"
docker rm -f $container_id
