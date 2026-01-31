cat > backup_configs.sh <<EOF
#!/bin/bash
# Backup the manually fixed .env file
mkdir -p ./config-backups
cp ../bookstack_config/www/.env ./config-backups/bookstack.env
echo "Manual configurations backed up to ./config-backups/"
EOF
chmod +x backup_configs.sh