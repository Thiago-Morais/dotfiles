function eclesyart-stop --wraps='docker compose -f ~/repos/third-party/frappe_docker/pwd.yml stop' --description 'alias eclesyart-stop=docker compose -f ~/repos/third-party/frappe_docker/pwd.yml stop'
    docker compose -f ~/repos/third-party/frappe_docker/pwd.yml stop $argv
end
