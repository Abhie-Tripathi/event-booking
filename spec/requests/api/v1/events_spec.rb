require 'swagger_helper'

RSpec.describe 'Events API', type: :request do
  path '/api/v1/events' do
    get 'List all events' do
      tags 'Events'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'events found' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Events retrieved successfully.' }
              }
            },
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  title: { type: :string },
                  description: { type: :string },
                  venue: { type: :string },
                  event_date: { type: :string, format: 'date-time' },
                  event_organizer_id: { type: :integer },
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

    post 'Create an event' do
      tags 'Events'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          event: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Tech Conference 2025' },
              description: { type: :string, example: 'Annual technology conference' },
              venue: { type: :string, example: 'Convention Center' },
              event_date: { type: :string, format: 'date-time', example: '2025-12-31T23:59:59Z' }
            },
            required: %w[title description venue event_date]
          }
        }
      }

      response '201', 'event created' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 201 },
                message: { type: :string, example: 'Event created successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                title: { type: :string },
                description: { type: :string },
                venue: { type: :string },
                event_date: { type: :string, format: 'date-time' },
                event_organizer_id: { type: :integer },
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

  path '/api/v1/events/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get event details' do
      tags 'Events'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'event found' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Event retrieved successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                title: { type: :string },
                description: { type: :string },
                venue: { type: :string },
                event_date: { type: :string, format: 'date-time' },
                event_organizer_id: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }
        run_test!
      end

      response '404', 'event not found' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end

    put 'Update event' do
      tags 'Events'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          event: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              venue: { type: :string },
              event_date: { type: :string, format: 'date-time' }
            }
          }
        }
      }

      response '200', 'event updated' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Event updated successfully.' }
              }
            },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                title: { type: :string },
                description: { type: :string },
                venue: { type: :string },
                event_date: { type: :string, format: 'date-time' },
                event_organizer_id: { type: :integer },
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

    delete 'Delete event' do
      tags 'Events'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'event deleted' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer, example: 200 },
                message: { type: :string, example: 'Event deleted successfully.' }
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
    end
  end
end 