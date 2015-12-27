require 'rails_helper'

describe 'Application Routing' do
  describe 'terms#index' do
    it 'routes GET / and GET /terms' do
      expect(get: '/').to route_to('terms#index')
      expect(root_path).to eq('/')

      expect(get: '/terms').to route_to('terms#index')
      expect(terms_path).to eq('/terms')
    end
  end
end
