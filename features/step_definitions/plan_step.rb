# frozen_string_literal: true

Given('the following plans exist:') do |table|
  table.hashes.each do |plan|
    Plan.create(plan)
  end
end

When('I add a step for {string} with the following details:') do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable
  step_attributes = table.hashes.first
  plan = Plan.find_by(name: string)
  @step = plan.steps.create!(step_attributes)
end

When('I click on the button with {string} icon for the plan {string} to enter the {string} page') do |string, string2, string3|
  plan = Plan.find_by(name: string2)
  find("##{string}_plan_#{plan.id}", match: :first).click
  # find("##{string}_plan_#{plan.id}").click
  sleep(1)
  if string3 == 'edit'
    expect(current_path).to eq(edit_plan_path(plan))
  elsif string3 == 'edit floorplans 2d'
    expect(current_path).to eq(floorplans2d_plan_path(plan))
  end
end

Then('I should see the name being updated to {string} in the list of plans') do |string|
  plan = Plan.find_by(name: string)
  expect(plan).not_to be_nil
end

When('I click on the {string} button') do |string|
  click_on(string)
  sleep(1)
end

Then('I fill in {string} with {string}') do |string, string2|
  fill_in(string, with: string2)
end

When('I set {string} with {string}') do |string, string2|
  page.execute_script("document.getElementById('#{string}').value = '#{string2}';")
end

Then('I fill in {string} with {double}') do |string, double|
  fill_in(string, with: double)
  sleep(1)
end

Then('I should see {string} in the list of plans') do |string|
  plan = Plan.find_by(name: string)
  expect(plan).not_to be_nil
end

Then('I should see a template of step being added') do
  expect(page.all('tbody#step-table-body tr').count).to eq(1)
end

Given('I am on the {string} page') do |string|
  case string
  when 'new plan'
    visit(new_plan_path)
    expect(current_path).to eq('/plans/new')
  when 'home'
    visit(root_path)
    expect(current_path).to eq('/') # Update the expected path to "/"
  when 'logout'
    expect(current_path).to eq('https://events360.herokuapp.com/logout')
  else
    visit(string)
    expect(current_path).to eq("/#{string}")
  end
end

Then('I should be on the {string} page') do |string|
  if string == 'new plan'
    expect(current_path).to eq('/plans/new')
  elsif string == 'home'
    expect(current_path).to eq('/') # Update the expected path to "/"
    # elsif string == 'Logout'
    # expect(current_path).to eq('https://events360.herokuapp.com/logout')
  else
    expect(current_path).to eq("/#{string}")
  end
  sleep(1)
end

Then('I should see {string} to have {int} step\(s)') do |string, int|
  plan = Plan.find_by(name: string)
  expect(plan.steps.count).to eq(int)
end

Then('I should be on the Event360 user page') do
  expect(page).to have_current_path('https://events360.herokuapp.com/users')
end
