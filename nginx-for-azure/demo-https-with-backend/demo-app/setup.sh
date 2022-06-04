#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

storage_account=$1

sudo apt update -y
sudo apt install -y nginx
sudo apt install unzip

wget "https://$storage_account.blob.core.windows.net/demo-app/contents.zip"
sudo apt install unzip

unzip contents.zip -d /home/azureuser

## now we need to update nginx to point to the content folder for the root directory

sudo tee /etc/nginx/nginx.conf <<EOF
events {

}

http {
    server {
        listen 80;
        location / {
            default_type text/html;
            root /home/azureuser/contents;
        }
    }
}
EOF

sudo tee /home/azureuser/contents/index.html <<EOF
<!DOCTYPE html><h2>Hello World from $HOSTNAME !</h2>
EOF

## Replace HOSTNAME everywhere with actual hostname
find /home/azureuser/contents/ -type f -exec sed -i 's/HOSTNAME/'"$HOSTNAME"'/g' {} \;

sudo nginx -s reload