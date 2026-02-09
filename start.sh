#!/bin/bash
set -e

# Set default API_URL if not provided
API_URL=${API_URL:-"http://localhost:3000/"}

echo "Configuring Swagger UI with API URL: $API_URL"

# Replace the default URL in swagger-initializer.js
# The default URL in the official image is typically https://petstore.swagger.io/v2/swagger.json
if [ -f /usr/share/nginx/html/swagger-initializer.js ]; then
	sed -i "s|https://petstore.swagger.io/v2/swagger.json|$API_URL|g" /usr/share/nginx/html/swagger-initializer.js
	# Also handle if it's already replaced or different in some versions
	sed -i "s|url: \".*\"|url: \"$API_URL\"|g" /usr/share/nginx/html/swagger-initializer.js
fi

# Start supervisor
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
