require 'swagger_helper'

RSpec.describe 'Bookings API', type: :request do
  path '/api/v1/bookings' do
    get 'List user bookings' do
      tags 'Bookings'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'bookings found' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Bookings retrieved successfully.' }
              }
            },
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  customer_id: { type: :integer },
                  ticket_id: { type: :integer },
                  quantity: { type: :integer },
                  total_price: { type: :number, format: 'float' },
                  status: { type: :string, enum: ['pending', 'confirmed', 'cancelled'] },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end

    post 'Create a booking' do
      tags 'Bookings'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      
      parameter name: :booking, in: :body, schema: {
        type: :object,
        properties: {
          booking: {
            type: :object,
            properties: {
              ticket_id: { type: :integer, example: 1 },
              quantity: { type: :integer, example: 2 }
            },
            required: %w[ticket_id quantity]
          }
        }
      }

      response '201', 'booking created' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 201 },
                message: { type: :string, example: 'Booking created successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                customer_id: { type: :integer },
                ticket_id: { type: :integer },
                quantity: { type: :integer },
                total_price: { type: :number, format: 'float' },
                status: { type: :string, enum: ['pending', 'confirmed', 'cancelled'] },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end

  path '/api/v1/bookings/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get booking details' do
      tags 'Bookings'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'booking found' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Booking retrieved successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                customer_id: { type: :integer },
                ticket_id: { type: :integer },
                quantity: { type: :integer },
                total_price: { type: :number, format: 'float' },
                status: { type: :string, enum: ['pending', 'confirmed', 'cancelled'] },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '403', 'forbidden' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '404', 'booking not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end

  path '/api/v1/bookings/{id}/cancel' do
    parameter name: :id, in: :path, type: :integer

    post 'Cancel booking' do
      tags 'Bookings'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'booking cancelled' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Booking cancelled successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                customer_id: { type: :integer },
                ticket_id: { type: :integer },
                quantity: { type: :integer },
                total_price: { type: :number, format: 'float' },
                status: { type: :string, enum: ['cancelled'] },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '403', 'forbidden' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '404', 'booking not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end
end 