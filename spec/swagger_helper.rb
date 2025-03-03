require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Event Booking API',
        version: 'v1',
        description: 'This is the API documentation for the Event Booking system. It provides endpoints for event organizers to create and manage events, and for customers to browse events and make bookings.'
      },
      paths: {},
      servers: [
        {
          url: 'https://event-booking-x21f.onrender.com',
          description: 'Production server'
        },
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ],
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT',
            description: 'JWT token obtained from login endpoint. Use format: Bearer <token>'
          }
        },
        schemas: {
          error: {
            type: :object,
            properties: {
              status: {
                type: :object,
                properties: {
                  code: { type: :integer },
                  message: { type: :string }
                }
              },
              errors: {
                type: :array,
                items: { type: :string }
              }
            }
          }
        }
      },
      security: [
        { bearer_auth: [] }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end 