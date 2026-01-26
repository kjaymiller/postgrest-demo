# PostgREST Demo

This project provides a simple setup to expose a PostgreSQL database as a RESTful API using [PostgREST](https://postgrest.org/). It includes a Docker configuration for running PostgREST, Swagger UI for documentation, and a SQL script to set up the necessary database permissions.

## Project Structure

- `Dockerfile.postgrest`: Configures the PostgREST container.
- `Dockerfile.swagger`: Configures the Swagger UI container.
- `docker-compose.yml`: Orchestrates both services.
- `permissions.sql`: SQL script to create the anonymous web role and grant read-only permissions to specific tables.

## Prerequisites

- [Docker](https://www.docker.com/)
- A running PostgreSQL database instance

## Setup

### 1. Database Configuration

Before running the API, you need to configure your PostgreSQL database. Run the `permissions.sql` script against your database to create the `web_anon` role and grant it access to the necessary tables:

```bash
psql -d <your_database_name> -f permissions.sql
```

The script grants `SELECT` permissions to the `web_anon` role for the following tables in the `public` schema:
- `blog`
- `conferences`
- `microblog`
- `notes`
- `tags`
- (and associated join tables)

### 2. Running with Docker Compose (Recommended)

This is the easiest way to run both PostgREST and Swagger UI.

1. Set the `PG_CONNECTION_STRING` environment variable with your database connection string.
   ```bash
   export PG_CONNECTION_STRING="postgres://user:password@host:port/dbname"
   ```

2. Start the services:
   ```bash
   docker compose up --build
   ```

The services will be available at:
- **API**: `http://localhost:3000`
- **Swagger UI**: `http://localhost:8080`

#### Changing the Swagger API URL (Docker Compose)

By default, Swagger UI points to `http://localhost:3000/`. To change this, you can modify the `API_URL` environment variable in `docker-compose.yml`:

```yaml
  swagger:
    ...
    environment:
      API_URL: http://your-custom-url:3000/
```

### 3. Running Manually

If you prefer to run the containers individually:

#### PostgREST Service

1. Build the image:
   ```bash
   docker build -t postgrest-demo -f Dockerfile.postgrest .
   ```

2. Run the container:
   ```bash
   docker run -p 3000:3000 \
     -e PGRST_DB_URI="postgres://user:password@host:port/dbname" \
     -e PGRST_DB_SCHEMA="public" \
     -e PGRST_DB_ANON_ROLE="web_anon" \
     postgrest-demo
   ```

#### Swagger UI Service

1. Build the image:
   ```bash
   docker build -t swagger-ui-demo -f Dockerfile.swagger .
   ```

2. Run the container:
   ```bash
   docker run -p 8080:8080 \
     -e API_URL="http://localhost:3000/" \
     swagger-ui-demo
   ```

#### Changing the Swagger API URL (Manual)

To change the target API URL when running manually, update the `-e API_URL` flag:

```bash
docker run -p 8080:8080 \
  -e API_URL="http://your-new-api-url:3000/" \
  swagger-ui-demo
```

## API Usage

Once running, you can access the API.

Example request:
```bash
curl http://localhost:3000/blog
```
