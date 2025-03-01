require 'swagger_helper'

RSpec.describe 'Tickets API', type: :request do
  path '/api/v1/events/{event_id}/tickets' do
    parameter name: :event_id, in: :path, type: :integer

    get 'List tickets for an event' do
      tags 'Tickets'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'tickets found' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Tickets retrieved successfully.' }
              }
            },
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  category: { type: :string },
                  price: { type: :number, format: 'float' },
                  quantity: { type: :integer },
                  event_id: { type: :integer },
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

      response '404', 'event not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end

    post 'Create tickets for an event' do
      tags 'Tickets'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      
      parameter name: :ticket, in: :body, schema: {
        type: :object,
        properties: {
          ticket: {
            type: :object,
            properties: {
              category: { type: :string, example: 'VIP' },
              price: { type: :number, format: 'float', example: 100.00 },
              quantity: { type: :integer, example: 50 }
            },
            required: %w[category price quantity]
          }
        }
      }

      response '201', 'ticket created' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 201 },
                message: { type: :string, example: 'Ticket created successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                category: { type: :string },
                price: { type: :number, format: 'float' },
                quantity: { type: :integer },
                event_id: { type: :integer },
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

      response '404', 'event not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end

  path '/api/v1/events/{event_id}/tickets/{id}' do
    parameter name: :event_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get 'Get ticket details' do
      tags 'Tickets'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'ticket found' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Ticket retrieved successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                category: { type: :string },
                price: { type: :number, format: 'float' },
                quantity: { type: :integer },
                event_id: { type: :integer },
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

      response '404', 'ticket not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end

    put 'Update ticket' do
      tags 'Tickets'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      
      parameter name: :ticket, in: :body, schema: {
        type: :object,
        properties: {
          ticket: {
            type: :object,
            properties: {
              category: { type: :string },
              price: { type: :number, format: 'float' },
              quantity: { type: :integer }
            }
          }
        }
      }

      response '200', 'ticket updated' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Ticket updated successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                category: { type: :string },
                price: { type: :number, format: 'float' },
                quantity: { type: :integer },
                event_id: { type: :integer },
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

      response '404', 'ticket not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end

    delete 'Delete ticket' do
      tags 'Tickets'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'ticket deleted' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Ticket deleted successfully.' }
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

      response '404', 'ticket not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end
end 