# Stage 1: Get PostgREST binary
FROM postgrest/postgrest:latest AS postgrest

# Stage 2: Get Swagger UI files
FROM swaggerapi/swagger-ui AS swagger

# Stage 3: Final Image
FROM debian:bookworm-slim

# Install dependencies
# libpq5 is required for PostgREST
# nginx is required for Swagger UI
# supervisor is required to run multiple processes
RUN apt-get update && apt-get install -y \
  nginx \
  supervisor \
  libpq5 \
  && rm -rf /var/lib/apt/lists/*

# Copy PostgREST binary
COPY --from=postgrest /bin/postgrest /usr/local/bin/postgrest

# Copy Swagger UI files
COPY --from=swagger /usr/share/nginx/html /usr/share/nginx/html

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/sites-enabled/default
COPY start.sh /start.sh

# Make start script executable
RUN chmod +x /start.sh

# Expose ports
# 3000: PostgREST
# 8080: Swagger UI
EXPOSE 3000 8080

CMD ["/start.sh"]
