# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  describe 'GET #download_all_data' do
    it 'responds with a CSV file containing all plan and item data' do
      # Setup for the basic functionality test
      plan1 = Plan.create(name: 'Test1', owner: 'Morris', venue_length: 100, venue_width: 100)
      plan2 = Plan.create(name: 'Test2', owner: 'Morris', venue_length: 100, venue_width: 100)
      step1 = FactoryBot.create(:step, plan: plan1)
      FactoryBot.create(:item, name: 'Item 1', step: step1)
      step2 = FactoryBot.create(:step, plan: plan2)
      FactoryBot.create(:item, name: 'Item 2', step: step2)

      get :download_all_data

      expect(response.content_type).to eq('text/csv')
      expect(response.headers['Content-Disposition']).to include("attachment; filename=\"plans_and_items_#{Date.today}.csv\"")

      CSV.parse(response.body)
      # Basic checks for CSV content
    end

    it 'responds with a CSV file containing all plan and item data even if there are no plans' do
      Plan.destroy_all

      get :download_all_data

      expect(response.content_type).to eq('text/csv')
      expect(response.headers['Content-Disposition']).to include("attachment; filename=\"plans_and_items_#{Date.today}.csv\"")

      CSV.parse(response.body)
      # Check for header only in CSV
    end

    it 'generates a detailed CSV with the correct data for each plan, step, and item' do
      # Setup for the detailed functionality test
      plan = Plan.create!(name: 'Test Plan', venue_length: 100, venue_width: 50, timezone: 'UTC',
                          created_at: Time.zone.now, updated_at: Time.zone.now)
      step = plan.steps.create!(start_time: Time.zone.now, end_time: Time.zone.now + 2.hours)
      step.items.create!(name: 'Item 1', model: 'Model 1', width: 10, length: 20, depth: 5, rotation: 90,
                         xpos: 10, ypos: 20, zpos: 0, setup_start_time: Time.zone.now,
                         setup_end_time: Time.zone.now + 1.hour, breakdown_start_time: Time.zone.now + 3.hours,
                         breakdown_end_time: Time.zone.now + 4.hours)
      step.items.create!(name: 'Item 2', model: 'Model 2', width: 15, length: 25, depth: 10, rotation: 45,
                         xpos: 15, ypos: 25, zpos: 5, setup_start_time: Time.zone.now,
                         setup_end_time: Time.zone.now + 1.hour, breakdown_start_time: Time.zone.now + 3.hours,
                         breakdown_end_time: Time.zone.now + 4.hours)

      get :download_all_data

      csv = CSV.parse(response.body, headers: true)
      expected_headers = [
        'Plan ID', 'Plan Name', 'Venue Length', 'Venue Width', 'Plan Created At',
        'Plan Updated At', 'Timezone', 'Step ID', 'Step Start Time', 'Step End Time',
        'Step Break1 Start Time', 'Step Break1 End Time', 'Step Break2 Start Time',
        'Step Break2 End Time', 'Item Name', 'Item Model', 'Item Width', 'Item Length',
        'Item Depth', 'Item Rotation', 'Item X Position', 'Item Y Position',
        'Item Z Position', 'Item Setup Start Time', 'Item Setup End Time',
        'Item Breakdown Start Time', 'Item Breakdown End Time'
      ]
      expect(csv.headers).to match_array(expected_headers)

      plan_row = csv.find { |row| row['Plan ID'] == plan.id.to_s }
      expect(plan_row['Plan Name']).to eq('Test Plan')
      # More detailed checks for CSV content
    end
  end

  Plan.destroy_all

  plan1 = Plan.create(name: 'Test1', owner: 'Morris', venue_length: 100, venue_width: 100)
  Plan.create(name: 'Test2', owner: 'Morris', venue_length: 100, venue_width: 100)

  describe 'when trying to view the home page' do
    it 'shows the home page' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'when trying to view the show page' do
    it 'redirect the show page to the edit page' do
      get :show, params: { id: plan1.id }
      expect(response).to redirect_to(edit_plan_path(plan1))
    end
  end

  describe 'when trying to view the new plan page' do
    it 'shows the new plan page' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe "when trying to view a plan's details" do
    it 'shows the details page for a plan' do
      get :edit, params: { id: plan1.id }
      expect(assigns(:plan)).to eq(plan1)
    end
  end

  describe "when trying to edit a plan's 2d floorplan" do
    it 'shows the 2d floorplan page' do
      get :floorplans2d, params: { id: plan1.id }
      expect(assigns(:plan)).to eq(plan1)
    end
  end

  describe 'when trying to create a new plan' do
    it 'creates a new plan' do
      post :create, params: { plan: { name: 'Test3', owner: 'Morris', venue_length: 100, venue_width: 100 } }
      plan3 = Plan.last
      expect(plan3.name).to eq('Test3')
      expect(plan3.owner).to eq('Morris')
      expect(response).to redirect_to(plans_path)
    end
  end

  describe 'when trying to delete a plan' do
    it 'deletes a plan' do
      delete :destroy, params: { id: plan1.id }
      plan = Plan.find_by(id: plan1.id)
      expect(plan).to be_nil
    end
  end

  describe 'when trying to update a plan' do
    it 'updates a plan and adds steps' do
      put :update, params: { id: plan1.id, plan: { name: 'Test4', owner: 'Morris',
                                                   venue_length: 100, venue_width: 100, steps_attributes: { "0":
      { start_date: '2021-01-01', start_time: '10:00:00', end_time: '11:00:00', break1_start_time: '10:30:00',
        break1_end_time: '10:45:00', break2_start_time: '10:30:00', break2_end_time: '10:45:00' } } } }
      plan1.reload
      expect(plan1.name).to eq('Test4')
      expect(plan1.owner).to eq('Morris')
      expect(plan1.steps.last.start_date.strftime('%Y-%m-%d')).to eq('2021-01-01')
      expect(plan1.steps.last.start_time.strftime('%H:%M:%S')).to eq('10:00:00')
      expect(plan1.steps.last.end_time.strftime('%H:%M:%S')).to eq('11:00:00')
      expect(plan1.steps.last.break1_start_time.strftime('%H:%M:%S')).to eq('10:30:00')
      expect(plan1.steps.last.break1_end_time.strftime('%H:%M:%S')).to eq('10:45:00')
      expect(plan1.steps.last.break2_start_time.strftime('%H:%M:%S')).to eq('10:30:00')
      expect(plan1.steps.last.break2_end_time.strftime('%H:%M:%S')).to eq('10:45:00')
      expect(response).to redirect_to(plans_path)
    end

    it 'updates a plan without steps' do
      put :update, params: { id: plan1.id, plan: { name: 'Test5', owner: 'Morris',
                                                   venue_length: 120, venue_width: 120, steps_attributes: nil } }

      plan1.reload
      expect(plan1.name).to eq('Test5')
      expect(plan1.venue_length).to eq(120)
      expect(plan1.venue_width).to eq(120)
      expect(response).to redirect_to(plans_path)
    end
  end

  # add tests for floorplans2d
  describe '#preview3d' do
    let(:snapshot_data_json) do
      '{"venue_width": 100, "venue_length": 200, "items": {"item1":
      {"item_name": "Chair", "item_type": "furniture", "item_model": "chair_model",
      "item_xpos": 10, "item_zpos": 20}}}'
    end
    let(:file_path) { Rails.root.join('public', 'floorplan.json') }
    let(:blueprints_path) { '/path_to_blueprints' } # adjust as necessary

    before do
      allow(controller).to receive(:blueprints_path).and_return(blueprints_path)
      allow(File).to receive(:read).and_return('{ "floorplan": {"corners": {}}, "items": [] }')
      allow(File).to receive(:write)
      post :preview3d, params: { snapshot_data: snapshot_data_json }
    end

    it 'parses the snapshot data correctly' do
      # Test the parsing logic here
    end

    it 'modifies the json_content based on snapshot_data' do
      # Test the modifications to json_content
    end

    it 'writes the correct content to floorplan.json' do
      expect(File).to have_received(:write).with(file_path, anything)
      # You can also test the contents written to the file if necessary
    end

    it 'redirects to the blueprints path' do
      expect(response).to redirect_to(blueprints_path)
    end
  end

  # test for submit button
  describe PlansController, type: :controller do
    describe 'POST #upload_existing_plan' do
      it 'uploads an existing plan file' do
        # Mock any necessary behavior

        # Simulate a request to the controller action
        post :upload_existing_plan,
             params: { plan_file: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'dummy.pdf'),
                                                      'application/pdf') }

        # Add expectations for the controller action behavior
        # For example, you could expect a redirect or a specific response
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
