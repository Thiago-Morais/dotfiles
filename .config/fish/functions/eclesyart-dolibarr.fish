function eclesyart-dolibarr --wraps='docker start dolibarr-mariadb-1  dolibarr-web-1' --description 'alias eclesyart-dolibarr docker start dolibarr-mariadb-1  dolibarr-web-1'
    docker start dolibarr-mariadb-1  dolibarr-web-1 $argv
end
