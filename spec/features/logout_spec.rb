# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Logout', type: :feature do
  scenario 'User logs out successfully' do
    # Visit the page where the logout link/button exists
    visit 'https://planxtwise-977c1a4011c1.herokuapp.com/plans'

    # Click the logout link/button
    click_on 'Logout'

    # Ensure that the user is redirected to the logout page
    expect(page).to have_current_path('https://events360.herokuapp.com/logout')
  end
end
