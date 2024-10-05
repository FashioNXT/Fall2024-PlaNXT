# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlueprintsController, type: :controller do
  describe 'GET #index' do
    let(:sample_json) do
      {
        "floorplan": {
          "corners": {
            "corner1": { "x": 0, "y": 0 },
            "corner2": { "x": 100, "y": 100 }
          },
          "walls": [],
          "wallTextures": [],
          "floorTextures": {},
          "newFloorTextures": {}
        },
        "items": [
          { "item_name": 'Red Chair', "xpos": 65.5, "ypos": 0, "zpos": 143.5 }
        ]
      }.to_json
    end
    let(:file_path) { Rails.root.join('public', 'floorplan.json') }

    before do
      allow(File).to receive(:read).with(file_path).and_return(sample_json)
      get :index
    end

    it 'reads the floorplan.json file' do
      expect(File).to have_received(:read).with(file_path)
    end

    it 'assigns the parsed JSON to @snapshot' do
      expected_data = JSON.parse(sample_json)
      expect(assigns(:snapshot)).to eq(expected_data)
    end

    it 'correctly parses the corners from the floorplan' do
      snapshot = assigns(:snapshot)
      expect(snapshot['floorplan']['corners']).to have_key('corner1')
      expect(snapshot['floorplan']['corners']).to have_key('corner2')
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end
end
