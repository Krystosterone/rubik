require 'rails_helper'

describe TermsController do
  describe '#index' do
    let!(:terms) { create_list(:term, 3) }
    before { get :index }

    it 'renders the index' do
      expect(response).to render_template(:index)
    end

    it 'assigns the terms' do
      expect(assigns(:terms)).to eq(terms.reverse)
    end
  end
end
