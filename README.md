# PostgREST Demo

This project provides a simple setup to expose a PostgreSQL database as a RESTful API using [PostgREST](https://postgrest.org/). It includes a Docker configuration for running PostgREST and a SQL script to set up the necessary database permissions.

## Project Structure

- `Dockerfile`: Configures the PostgREST container.
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

### 2. Build the Docker Image

Build the Docker image using the provided Dockerfile:

```bash
docker build -t postgrest-demo .
```

### 3. Run the Container

Run the container, providing the connection URI to your PostgreSQL database via the `PGRST_DB_URI` environment variable.

```bash
docker run -p 3000:3000 \
  -e PGRST_DB_URI="postgres://user:password@host:port/dbname" \
  postgrest-demo
```

Replace `user:password@host:port/dbname` with your actual database credentials.

## Configuration

The Docker container is configured with the following defaults (defined in `Dockerfile`):

- `PGRST_DB_SCHEMA`: `public`
- `PGRST_DB_ANON_ROLE`: `web_anon`

You can override these by passing `-e` flags to the `docker run` command.

## Usage

Once running, the API will be available at `http://localhost:3000`.

Example request:
```bash
curl http://localhost:3000/blog
```
