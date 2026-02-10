# PostgREST Demo

This project provides a unified Docker image to expose a PostgreSQL database as a RESTful API using [PostgREST](https://postgrest.org/) and serve [Swagger UI](https://swagger.io/tools/swagger-ui/) for documentation.

It uses `supervisord` to run both PostgREST and Nginx (for Swagger UI) in a single container.

## Project Structure

- `Dockerfile`: Multi-stage build that packages PostgREST and Swagger UI.
- `nginx.conf`: Nginx configuration for serving Swagger UI.
- `supervisord.conf`: Supervisor configuration to manage PostgREST and Nginx processes.
- `start.sh`: Entrypoint script to configure the Swagger UI API URL and start Supervisor.
- `permissions.sql`: SQL script to set up the necessary database permissions.

## Prerequisites

- [Docker](https://www.docker.com/)
- A running PostgreSQL database instance

## Setup

### 1. Database Configuration

Before running the API, configure your PostgreSQL database. Run the `permissions.sql` script to create the `web_anon` role and grant it access to the necessary tables:

```bash
psql -d <your_database_name> -f permissions.sql
```

This grants `SELECT` permissions to the `web_anon` role for specific tables in the `public` schema.

### 2. Build the Docker Image

```bash
docker build -t postgrest-demo .
```

### 3. Run the Container

Run the container, providing the database connection string. Ensure the container can access your host's network if the database is running locally (e.g., using `host.docker.internal` on Mac/Windows or `--network host` on Linux).

```bash
docker run -p 3000:3000 -p 8080:8080 \
  -e PGRST_DB_URI="postgres://user:password@host:port/dbname" \
  -e PGRST_DB_SCHEMA="public" \
  -e PGRST_DB_ANON_ROLE="web_anon" \
  -e API_URL="http://localhost:3000/" \
  postgrest-demo
```

The services will be available at:
- **API**: `http://localhost:3000`
- **Swagger UI**: `http://localhost:8080`

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PGRST_DB_URI` | PostgreSQL connection string | (Required) |
| `PGRST_DB_SCHEMA` | Schema to expose | `public` |
| `PGRST_DB_ANON_ROLE` | Database role for anonymous requests | `web_anon` |
| `API_URL` | URL that Swagger UI should point to | `http://localhost:3000/` |

## API Usage

Once running, you can access the API directly or via Swagger UI.

Example request:
```bash
curl http://localhost:3000/blog
```
