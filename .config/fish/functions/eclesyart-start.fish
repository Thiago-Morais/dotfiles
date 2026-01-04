function eclesyart-start --wraps='docker compose -f ~/repos/third-party/frappe_docker/pwd.yml up -d' --description 'alias eclesyart-start docker compose -f ~/repos/third-party/frappe_docker/pwd.yml up -d'
    docker compose -f ~/repos/third-party/frappe_docker/pwd.yml up -d $argv
end
