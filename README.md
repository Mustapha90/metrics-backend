
# Metrics Rails API with TimescaleDB for time series storage

This Rails API application is designed to serve metrics, leveraging TimescaleDB for time-series data storage. Allowing fast retrieval for aggragated calculations on base metrics data, supporting several metric types.

## Tools used

- **TimescaleDB**: Efficient storage and querying of time-series data.
- **Docker containers**: Simplifies the setup of the development and production environment.
- **Rswag**: Maintains tight code and documentation synchronization.
- **Rubocop**: Ensures code quality and style consistency.
- **Rspec**: Comprehensive testing framework.

## Getting Started

### Prerequisites

- Docker and Docker Compose installed on your machine.

### Installation

Clone the repository and navigate to the project directory. Then, run the following commands to set up the application:

```bash
make install
make up
```

NOTE: make install is run only the first time you clone the repository, for subsequent installation or updates use **make build** command

### Environment Variables

Create a `.env.development` file based on the provided `.env.development.example`:

```dotenv
RAILS_ENV=development
POSTGRES_DB=your_db_name
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_db_password
POSTGRES_HOST=db
DATABASE_URL=postgres://your_db_user:your_db_password@db:5432/your_db_name
RAILS_MAX_THREADS=5
```

### Makefile Commands

- `make up`: Start the application using Docker Compose.
- `make build`: Build the Docker images.
- `make down`: Stop the application.
- `make clean`: Stop the application and remove volumes.
- `make restart`: Restart the application.
- `make migrate`: Run database migrations.
- `make create-db`: Create the database.
- `make drop-db`: Drop the database.
- `make seed`: Seed the database.
- `make shell`: Open a shell in the API container.
- `make console`: Open a Rails console in the API container.
- `make test`: Run tests.
- `make logs`: Tail the application logs.
- `make swag`: Generate Swagger documentation.
- `make install`: Build the Docker images, create the database, run migrations, and seed the database.

### API Documentation

Rswag provides interactive API documentation available at:

[http://localhost:3000/api-docs](http://localhost:3000/api-docs)

### Example Endpoint

The application provides a paginated metrics aggregation endpoint. Example usage:

```
GET http://localhost:3000/api/v1/metrics/aggs/electricity_consumption/1m?page=1&per_page=100
```

Response structure:

```json
{
  "metadata": {
    "metric_type": {
      "code": "electricity_consumption",
      "name": "Electricity Consumption",
      "description": "The amount of electricity consumed."
    },
    "frequency": "1m",
    "total_pages": 2,
    "current_page": 1,
    "next_page": 2,
    "prev_page": null,
    "total_count": 120
  },
  "data": [
    {
      "avg_value": 318.7,
      "max_value": 498,
      "min_value": 103,
      "timestamp": "2024-04-16T19:09:00.000Z"
    },
    ...
  ]
}
```

Error response example:

```json
{
  "errors": [
    {
      "message": "Metric type not found"
    }
  ]
}
```

### Additional Notes

- **CORS**: Cross-Origin Resource Sharing (CORS) is configured.
- **Port**: The application is configured to start on port 3000.
