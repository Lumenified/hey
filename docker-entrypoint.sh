#!/bin/bash
set -e

# Run Laravel commands here
if [ ! -f /var/www/html/.env ]; then
    cp /var/www/html/.env.example /var/www/html/.env
fi

# Generate application key if not present
php artisan key:generate

# Execute the default command
exec "$@"
