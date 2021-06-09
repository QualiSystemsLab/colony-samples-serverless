#!/bin/bash -xe

# set -e  # Stop Script on Error

# save all env for debugging
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt

apt-get update -y

echo '==> Install nginx'
apt-get install nginx -y

if [ "$WEBAPP_ENDPOINT" != "none" ]  # if not 'none' configure NGINX
then
    echo '==> Configure nginx'
    cd /etc/nginx/sites-available/
    cp default default.backup  # backup default config

    cat << EOF > ./default
server {
    listen $PORT;
    listen [::]:$PORT;
    server_name _;
    rewrite ^/$ $WEBAPP_ENDPOINT permanent;
}
EOF
    # restart nginx
    echo '==> Restart nginx'
    systemctl restart nginx
    echo '==> Done restart nginx'
fi