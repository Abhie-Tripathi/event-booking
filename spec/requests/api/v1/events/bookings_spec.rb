require 'swagger_helper'

RSpec.describe 'Api::V1::Events::Bookings', type: :request do
  path '/api/v1/events/{event_id}/bookings' do
    get 'List all bookings for an event' do
      tags 'Event Bookings'
      description 'Returns all bookings for a specific event (Event Organizer only)'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :event_id, in: :path, type: :integer, required: true

      response '200', 'bookings found' do
        let(:event_organizer) { create(:event_organizer) }
        let(:event) { create(:event, event_organizer: event_organizer) }
        let(:ticket) { create(:ticket, event: event) }
        let(:customer) { create(:customer) }
        let!(:booking) { create(:booking, ticket: ticket, customer: customer) }
        let(:event_id) { event.id }
        let(:Authorization) { "Bearer #{generate_token_for(event_organizer)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.first).to include(
            'id',
            'quantity',
            'total_amount',
            'status',
            'customer',
            'ticket',
            'event'
          )
        end
      end

      response '401', 'unauthorized' do
        let(:event_id) { 1 }
        run_test!
      end

      response '403', 'forbidden - not the event organizer' do
        let(:other_event_organizer) { create(:event_organizer) }
        let(:event) { create(:event, event_organizer: other_event_organizer) }
        let(:event_id) { event.id }
        let(:unauthorized_organizer) { create(:event_organizer) }
        let(:Authorization) { "Bearer #{generate_token_for(unauthorized_organizer)}" }

        run_test!
      end

      response '404', 'event not found' do
        let(:event_organizer) { create(:event_organizer) }
        let(:event_id) { 999999 }
        let(:Authorization) { "Bearer #{generate_token_for(event_organizer)}" }

        run_test!
      end
    end
  end
end 