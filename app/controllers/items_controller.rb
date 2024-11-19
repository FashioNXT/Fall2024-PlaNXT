# frozen_string_literal: true

# ItemsController handles the CRUD actions for items, including creation,
# updating, deletion, and searching for items by step_id.
class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  # POST /items or /items.json
  def create
    Rails.logger.debug "Item params: #{item_params.inspect}"
    puts "Item params: #{item_params.inspect}" # Use puts for direct output if logging isn't working

    @item = Item.new(item_params.except(:dependencies))

    if @item.save
      if params[:item][:dependencies].present?
        Rails.logger.debug("Dependencies: #{params[:item][:dependencies].inspect}") # anprasa
        dependency_ids = params[:item][:dependencies].map(&:to_i) 
        dependencies = Item.where(id: dependency_ids)
      
        # Assign the dependencies
        @item.dependencies = dependencies
      end
      render json: @item, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # Fetch dependencies for a specific item
  def dependencies
    @item = Item.find(params[:id])
    @dependencies = @item.dependencies.select(:id, :name)

    # Return dependencies as JSON
    render json: @dependencies
  end

  # Search for items by step_id
  def search
    @items = Item.where(step_id: params[:step_id])
    render json: @items
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    return unless @item.update(item_params)

    render json: @item, status: :ok
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # Retrieves all items from the database and assigns them to the instance variable
  # @items to be used in plans_controller to download all data.
  def index
    @items = Item.all
    render json: @items
  end

  private
  

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(
      :name, :model, :width, :length, :depth, :rotation, :description,
      :xpos, :ypos, :zpos, :step_id, :setup_start_time, :setup_end_time,
      :breakdown_start_time, :breakdown_end_time,
      dependencies: []
    )
  end
end
