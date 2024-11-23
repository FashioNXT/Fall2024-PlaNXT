# frozen_string_literal: true

Then('It should load all the items in the floorplans 2d page') do
  page.execute_script('generateItems();')
  sleep(1)
end

When('I click on the {string} Accordion') do |string|
  click_on(string)
end

Then('I should see the {string} Accordion expand') do |string|
  expect(page).to have_css("div#flush-collapse#{string}.show")
end

def drag_to_exact_position(source, target, x_offset, y_offset)
  source_size = source.native.size
  target_size = target.native.size

  # Calculate offsets to move to the top-left corner of the target
  top_left_x_offset = -(target_size.width / 2).to_i
  top_left_y_offset = -(target_size.height / 2).to_i

  # Adjust the target x and y based on the source size (draggable item size)
  adjusted_x_offset = x_offset + (source_size.width / 2).to_i
  adjusted_y_offset = y_offset + (source_size.height / 2).to_i

  page.driver.browser.action.click_and_hold(source.native)
      .move_to(target.native)
      .move_by(top_left_x_offset + adjusted_x_offset, top_left_y_offset + adjusted_y_offset)
      .release
      .perform
end

When('I drag {string} from the {string} Accordion and drop at x={int}, y={int} on the canvas') do |string, _string2, int, int2|
  draggable = find("#item-#{string}")
  dropzone = find('#dropzone')

  # Determine the target position within the dropzone where you want the item to be dropped.
  # Adjust these values according to your test needs.
  target_x = int # example x-coordinate
  target_y = int2 # example y-coordinate

  drag_to_exact_position(draggable, dropzone, target_x, target_y)
end

Then('I should see the item {string} appear on the canvas at x={int}, y={int}') do |_string, int, int2|
  dropzone = find('#dropzone')

  # Shows the html
  puts page.html
  # Check if the element is present on the canvas
  item_on_dropzone = dropzone.find('.draggable')

  # Check the position of the item
  item_location = item_on_dropzone.native.location

  top_margin = page.evaluate_script("window.getComputedStyle(document.querySelector('.draggable')).marginTop")
  left_margin = page.evaluate_script("window.getComputedStyle(document.querySelector('.draggable')).marginLeft")

  # Adjusting the expected position based on the canvas top-left corner
  dropzone_location = dropzone.native.location
  expected_x = dropzone_location.x.to_i + int + left_margin.to_i
  expected_y = dropzone_location.y.to_i + int2 + top_margin.to_i

  # Assert the position
  expect(item_location.x.to_i).to eq(expected_x)
  expect(item_location.y.to_i).to eq(expected_y)
  sleep(1)
end

Then('I should see the item {string} appear in the table') do |string|
  itemsTable = find('#itemsTable')
  expect(itemsTable).to have_content(string)
end

Given('I am on the Floor Plan 2D page') do
  # Create a plan with a specific ID or let the database auto-assign an ID
  plan = Plan.create!(name: 'Test Plan', venue_length: 100, venue_width: 50, timezone: 'UTC',
                      created_at: Time.zone.now, updated_at: Time.zone.now)
  step = plan.steps.create!(start_time: Time.zone.now, end_time: Time.zone.now + 2.hours)

  # Visit the floorplans 2D page for the created plan
  visit "/plans/#{plan.id}/floorplans2d"
end

When('I click the "Save" link') do
  click_link('Save')
end

Then('I should receive a downloaded CSV file') do
  # Instead of relying on real-time file download, which can be unpredictable and challenging to test,
  # I mock the download process to test the response's content type and disposition
  # without actually downloading the file. This approach focuses on ensuring that the server intends
  # to send a file download response.
  # expect(page.response_headers['Content-Type']).to include('text/csv')
  # expect(page).to have_link('Save', href:'http://')
  click_link 'Save'
  # Wait for a moment to give the download time to complete (this can be adjusted as needed)
  sleep(5)

  # Check if the CSV file has been downloaded
  download_path = "#{Dir.home}/Downloads"
  expect(Dir.glob("#{download_path}/*.csv").any?).to be true
  # Further checks can be added here as needed
end
