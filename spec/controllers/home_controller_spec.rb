# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'when trying to view the home page' do
    it 'shows the home page' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
