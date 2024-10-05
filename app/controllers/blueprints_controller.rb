# frozen_string_literal: true

class BlueprintsController < ApplicationController
  layout 'layouts/blueprints'

  def index
    # sending data to 3d module
    # render '/docs/index.html'
    # ADDED HERE, read the saved floorplan.json from public folder, render in 3D when page is opened
    @snapshot = JSON.parse(File.read(Rails.root.join('public', 'floorplan.json')))
  end
end
