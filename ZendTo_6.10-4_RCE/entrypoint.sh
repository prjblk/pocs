#!/bin/bash

# Start Apache
service apache2 start

# Start PHP-FPM
service php7.4-fpm start

# Keep container running
tail -f /dev/null
