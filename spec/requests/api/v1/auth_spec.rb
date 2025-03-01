require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/v1/event_organizers' do
    post 'Register event organizer' do
      tags 'Event Organizers'
      consumes 'application/json'
      produces 'application/json'
      security [] # Public endpoint - no authentication required
      
      parameter name: :event_organizer, in: :body, schema: {
        type: :object,
        properties: {
          event_organizer: {
            type: :object,
            properties: {
              email: { type: :string, example: 'organizer@example.com' },
              password: { type: :string, example: 'password123' },
              name: { type: :string, example: 'John Doe' }
            },
            required: %w[email password name]
          }
        }
      }

      response '200', 'event organizer registered' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Registered successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string },
                token: { type: :string }
              }
            }
          }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end

  path '/api/v1/event_organizers/sign_in' do
    post 'Login event organizer' do
      tags 'Event Organizers'
      consumes 'application/json'
      produces 'application/json'
      security [] # Public endpoint - no authentication required
      
      parameter name: :event_organizer, in: :body, schema: {
        type: :object,
        properties: {
          event_organizer: {
            type: :object,
            properties: {
              email: { type: :string, example: 'organizer@example.com' },
              password: { type: :string, example: 'password123' }
            },
            required: %w[email password]
          }
        }
      }

      response '200', 'login successful' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Logged in successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string },
                token: { type: :string }
              }
            }
          }
        run_test!
      end

      response '401', 'invalid credentials' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end

  path '/api/v1/customers' do
    post 'Register customer' do
      tags 'Customers'
      consumes 'application/json'
      produces 'application/json'
      security [] # Public endpoint - no authentication required
      
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          customer: {
            type: :object,
            properties: {
              email: { type: :string, example: 'customer@example.com' },
              password: { type: :string, example: 'password123' },
              name: { type: :string, example: 'Jane Smith' }
            },
            required: %w[email password name]
          }
        }
      }

      response '200', 'customer registered' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Registered successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string },
                token: { type: :string }
              }
            }
          }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end

  path '/api/v1/customers/sign_in' do
    post 'Login customer' do
      tags 'Customers'
      consumes 'application/json'
      produces 'application/json'
      security [] # Public endpoint - no authentication required
      
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          customer: {
            type: :object,
            properties: {
              email: { type: :string, example: 'customer@example.com' },
              password: { type: :string, example: 'password123' }
            },
            required: %w[email password]
          }
        }
      }

      response '200', 'login successful' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Logged in successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string },
                token: { type: :string }
              }
            }
          }
        run_test!
      end

      response '401', 'invalid credentials' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end
end 