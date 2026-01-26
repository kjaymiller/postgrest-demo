# Use the official PostgREST image
FROM postgrest/postgrest:latest

# Expose the standard PostgREST port
EXPOSE 3000

# Set default configuration environment variables
# These can be overridden when running the container
ENV PGRST_DB_SCHEMA="public"
ENV PGRST_DB_ANON_ROLE="web_anon"

# The PGRST_DB_URI variable must be passed at runtime
# Example: docker run -e PGRST_DB_URI=$PG_CONNECTION_STRING ...
