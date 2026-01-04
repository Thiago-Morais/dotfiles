function eclesyart-down --wraps='docker compose -f ~/repos/third-party/frappe_docker/pwd.yml down' --description 'alias eclesyart-down=docker compose -f ~/repos/third-party/frappe_docker/pwd.yml down'
    docker compose -f ~/repos/third-party/frappe_docker/pwd.yml down $argv
end
