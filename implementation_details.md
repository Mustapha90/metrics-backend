
# Implementation Walkthrough

## Problem Definition

We need to develop a frontend and backend application that allows storing and visualizing metrics efficiently. Each metric will have a timestamp, name, and value. The metrics will be displayed in a timeline and must show averages per minute, hour, and day. These metrics will be persisted in a database.

### Simplified Approach

To streamline the process, we will focus on storing and querying the metrics rather than implementing full CRUD operations. The insertion of metrics will be assumed to be handled by a queue system like SQS or Kafka, where various applications can send their metrics, and a consumer service will insert these metrics into the database. For the purpose of this implementation, we will seed the database with sample metrics and work on querying and visualizing them. This approach allows us to showcase our ability to handle the challenging aspects of storing and querying time-series data.

## Straightforward Approach

**Proposal**: Use a relational database like PostgreSQL to store metrics and implement cron jobs or background workers to compute aggregates on the fly each time the endpoint is called.

**Trade-offs**:
1. **Storage Growth**: Storing metrics at the second granularity leads to rapid table growth.
2. **Performance**: Aggregating data on the fly during each endpoint call is computationally expensive and not scalable.
3. **Maintenance**: Cron jobs add complexity and increase the maintenance burden.

## Time-Series Data Considerations

When dealing with time-series data, there are inherent properties and challenges that need specialized handling. Time-series data is continuous in time and often requires frequent aggregations and computations. Several databases are optimized for such use cases, including:

- InfluxDB
- Prometheus
- OpenTSDB
- TimescaleDB

These databases provide built-in optimizations for time-series data, such as efficient storage, fast querying, and automatic aggregation. [Read more about time-series databases](https://thenewstack.io/what-are-time-series-databases-and-why-do-you-need-them/).

## Chosen Approach

**Proposal**: Utilize TimescaleDB for efficient time-series data storage and continuous aggregation, paired with a Rails API backend and a React frontend.

### Why TimescaleDB?

TimescaleDB is optimized for time-series data, providing efficient storage, querying, and aggregation. It is also an extension of PostgreSQL, making it fully compatible with PostgreSQL and Rails.

### Backend Architecture

#### Data Management

**TimescaleDB Gem**:
TimescaleDB has a rails gem than can be used to ease development it provides:
  - **Helper Methods**: Provides methods for managing hypertables and continuous aggregates.
  - **Schema Dumping Tools**: Simplifies schema management across environments.
  - **Integration with Scenic**: Offers potential for easier view management (discussed further in Future Improvements).

**Implementation details**
- **Base Table**: The metrics table is defined as a hypertable and acts as the source of truth. It will be used to create aggregate views.
- **Materialized Views**: Used for different aggregation frequencies (1m, 1h, 1d). Aggregates at higher frequencies are computed from lower frequencies (e.g., 1h from 1m). Pre-calculated aggregates ensure fast query responses without real-time computation. TimescaleDB allows modification of views without losing data, supporting easy schema evolution.
- **Metric Type Table**: Created separately to normalize metric types and avoid data repetition. An index on the metric type and metrics table speeds up queries.

#### API

**Kaminari for Pagination**:
Efficient handling of large datasets by paginating responses allowing fetching large amount of data efficiently.

**Rswag for Documentation**:
Provides interactive API documentation tightly coupled with tests to prevent code and documentation divergence.

### Frontend Architecture

**React**: Used for building the frontend of the application.

**Chart.js and React-Chartjs-2**:
Provides powerful and flexible charting capabilities.

**Component Structure**:
- **App**: Main entry point of the application.
- **MetricsViewer**: Handles user input for metric type and frequency.
- **MetricChart**: Fetches and prepares data for visualization using Chart.js.

**Axios**: Used for making requests to the API.

**Jest**: Used for testing the application.

## Future Improvements

### Integration of Scenic for View Management

**Current Challenge**:
While the current setup with materialized views in TimescaleDB efficiently handles aggregations, managing changes to these views can become complex, especially as the application evolves and new requirements emerge.

**Proposed Solution**: 
Integrate the timescaledb gem [Scenic](https://github.com/scenic-views/scenic) gem to manage database views with ease.
I aleady reached out to the team of timescaledb gem and they provided a guide on how to do it here: [timescaledb + scenic](https://github.com/jonatas/timescaledb/issues/65)

**Benefits**:
1. **Versioning**: Scenic allows versioning of views, making it easier to track changes over time and rollback if necessary.
2. **Ease of Maintenance**: Simplifies the process of updating views by generating migration files for changes, ensuring that modifications are applied seamlessly without data loss.
3. **Consistency**: By using Scenic, developers can ensure that the view definitions remain consistent across different environments (development, staging, production).

### Additional Enhancements

**Retention Policies and Downsampling**:
- **Retention Policies**: Implement automated retention policies to manage the growing data by archiving or deleting old records that are no longer needed.
- **Downsampling**: Use downsampling techniques to reduce the granularity of older data, preserving storage while maintaining essential historical insights.

**Improved Frontend Features**:
- **Features**: Add more features such as filter options, export functionality, and more detailed data visualization.
- **Responsive Design**: Ensure that the frontend is fully responsive, providing an optimal experience across all devices.

## References

- [TimescaleDB Documentation](https://docs.timescale.com/)
- [TimescaleDB Gem Documentation](https://github.com/jonatas/timescaledb)
- [Scenic Gem Documentation](https://github.com/scenic-views/scenic)
- [Kaminari Pagination](https://github.com/kaminari/kaminari)
- [React-Chartjs-2 Documentation](https://github.com/reactchartjs/react-chartjs-2)
- [What are time-series databases and why do you need them?](https://thenewstack.io/what-are-time-series-databases-and-why-do-you-need-them/)
