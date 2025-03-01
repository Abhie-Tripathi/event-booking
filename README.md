# Event Booking API

A Ruby on Rails API for event booking and management.

## API Documentation

The API documentation is available through Swagger UI at `/api-docs`. After starting the server, visit:

```
http://localhost:3000/api-docs
```

This provides an interactive documentation where you can:
- View all available endpoints
- Read detailed request/response schemas
- Test the API endpoints directly from the browser
- View authentication requirements for protected routes

## Authentication

The API uses JWT (JSON Web Token) authentication. Include the JWT token in the Authorization header for authenticated requests:

```
Authorization: Bearer <your_jwt_token>
```

## API Endpoints

### Authentication Routes

#### Event Organizers

1. **Register Event Organizer**
   - `POST /api/v1/event_organizers`
   - Request body:
     ```json
     {
       "event_organizer": {
         "email": "organizer@example.com",
         "password": "password123",
         "name": "John Doe"
       }
     }
     ```
   - Response:
     ```json
     {
       "status": {
         "code": 200,
         "message": "Registered successfully."
       },
       "data": {
         "id": 1,
         "email": "organizer@example.com",
         "name": "John Doe",
         "token": "your_jwt_token"
       }
     }
     ```

2. **Login Event Organizer**
   - `POST /api/v1/event_organizers/sign_in`
   - Request body:
     ```json
     {
       "event_organizer": {
         "email": "organizer@example.com",
         "password": "password123"
       }
     }
     ```
   - Response:
     ```json
     {
       "status": {
         "code": 200,
         "message": "Logged in successfully."
       },
       "data": {
         "id": 1,
         "email": "organizer@example.com",
         "name": "John Doe",
         "token": "your_jwt_token"
       }
     }
     ```

#### Customers

1. **Register Customer**
   - `POST /api/v1/customers`
   - Request body:
     ```json
     {
       "customer": {
         "email": "customer@example.com",
         "password": "password123",
         "name": "Jane Smith"
       }
     }
     ```
   - Response:
     ```json
     {
       "status": {
         "code": 200,
         "message": "Registered successfully."
       },
       "data": {
         "id": 1,
         "email": "customer@example.com",
         "name": "Jane Smith",
         "token": "your_jwt_token"
       }
     }
     ```

2. **Login Customer**
   - `POST /api/v1/customers/sign_in`
   - Request body:
     ```json
     {
       "customer": {
         "email": "customer@example.com",
         "password": "password123"
       }
     }
     ```
   - Response:
     ```json
     {
       "status": {
         "code": 200,
         "message": "Logged in successfully."
       },
       "data": {
         "id": 1,
         "email": "customer@example.com",
         "name": "Jane Smith",
         "token": "your_jwt_token"
       }
     }
     ```

### Protected Routes

These routes require authentication (JWT token in Authorization header)

#### Events
- `GET /api/v1/events` - List all events
- `POST /api/v1/events` - Create a new event (Event Organizer only)
- `GET /api/v1/events/:id` - Get event details
- `PUT /api/v1/events/:id` - Update event (Event Organizer only)
- `DELETE /api/v1/events/:id` - Delete event (Event Organizer only)

#### Tickets
- `GET /api/v1/events/:event_id/tickets` - List tickets for an event
- `POST /api/v1/events/:event_id/tickets` - Create tickets for an event (Event Organizer only)
- `GET /api/v1/events/:event_id/tickets/:id` - Get ticket details
- `PUT /api/v1/events/:event_id/tickets/:id` - Update ticket (Event Organizer only)
- `DELETE /api/v1/events/:event_id/tickets/:id` - Delete ticket (Event Organizer only)

#### Bookings
- `GET /api/v1/bookings` - List user's bookings (Customer only)
- `POST /api/v1/bookings` - Create a booking (Customer only)
- `GET /api/v1/bookings/:id` - Get booking details
- `POST /api/v1/bookings/:id/cancel` - Cancel booking (Customer only)

## Error Responses

The API returns appropriate HTTP status codes and error messages:

```json
{
  "status": {
    "code": 422,
    "message": "Registration failed."
  },
  "errors": [
    "Email has already been taken",
    "Password is too short"
  ]
}
```

Common status codes:
- 200: Success
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 422: Unprocessable Entity
- 500: Internal Server Error

## Development Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Setup database:
   ```bash
   rails db:create db:migrate
   ```
4. Start the server:
   ```bash
   rails server
   ```
5. Start Sidekiq for background jobs:
   ```bash
   bundle exec sidekiq
   ```

## Requirements

- Ruby 3.4.2
- Rails 8.0.1
- PostgreSQL
- Redis (for Sidekiq)
