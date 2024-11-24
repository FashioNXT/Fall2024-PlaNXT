# frozen_string_literal: true

# ItemsController handles the CRUD actions for items, including creation,
# updating, deletion, and searching for items by step_id.
class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  # POST /items or /items.json
  def create
    @item = Item.new(item_params.except(:dependencies))

    if @item.save
      if params[:item][:dependencies].present?
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

  # PATCH/PUT /items/1 or /items/1.json

  def update
    @item = Item.find(params[:id])

    # Capture original times before the update
    original_times = {
      setup_start_time: @item.setup_start_time,
      setup_end_time: @item.setup_end_time,
      breakdown_start_time: @item.breakdown_start_time,
      breakdown_end_time: @item.breakdown_end_time
    }

    # Update item attributes excluding dependencies
    if @item.update(item_params.except(:dependencies))
      # Handle dependencies if present in the params
      if params[:item][:dependencies].present?
        dependency_ids = params[:item][:dependencies].map(&:to_i)
        dependencies = Item.where(id: dependency_ids)
        @item.dependencies = dependencies # Save the dependencies
      end

      # Extract updated times after the update
      updated_times = {
        setup_start_time: @item.setup_start_time,
        setup_end_time: @item.setup_end_time,
        breakdown_start_time: @item.breakdown_start_time,
        breakdown_end_time: @item.breakdown_end_time
      }

      # Recursively update dependent items with proportional changes
      update_time_dependencies(@item, original_times, updated_times)

      render json: { status: 'success', item: @item }, status: :ok
    else
      render json: { status: 'error', message: @item.errors.full_messages }, status: :unprocessable_entity
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

  # DELETE /items/1 or /items/1.json
  def destroy
    if @item.destroy
      respond_to do |format|
        format.json { render json: { message: 'Item successfully deleted' }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { error: 'Failed to delete item' }, status: :unprocessable_entity }
      end
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

  def update_time_dependencies(item, original_times, updated_times, visited = Set.new)
    return if visited.include?(item.id) # Avoid infinite loops

    visited.add(item.id)

    # Calculate the time differences for start and end times
    setup_start_time_diff = (updated_times[:setup_start_time] || 0) - (original_times[:setup_start_time] || 0)
    setup_end_time_diff = (updated_times[:setup_end_time] || 0) - (original_times[:setup_end_time] || 0)
    breakdown_start_time_diff = (updated_times[:breakdown_start_time] || 0) - (original_times[:breakdown_start_time] || 0)
    breakdown_end_time_diff = (updated_times[:breakdown_end_time] || 0) - (original_times[:breakdown_end_time] || 0)

    setup_time_diff = setup_start_time_diff + (setup_end_time_diff - setup_start_time_diff)
    breakdown_time_diff = breakdown_start_time_diff + (breakdown_end_time_diff - breakdown_start_time_diff)

    # Print the size of reverse_dependencies
    reverse_dependencies_size = item.reverse_dependencies.size
    Rails.logger.info "Item #{item.id} has #{reverse_dependencies_size} reverse dependencies."

    # Update each dependent item
    item.reverse_dependencies.each do |dependent_item|
      # Calculate new times for the dependent item
      new_setup_start_time = dependent_item.setup_start_time + setup_time_diff
      new_setup_end_time = dependent_item.setup_end_time + setup_time_diff
      new_breakdown_start_time = dependent_item.breakdown_start_time + breakdown_time_diff
      new_breakdown_end_time = dependent_item.breakdown_end_time + breakdown_time_diff

      # Update the dependent item's times
      dependent_item.update(
        setup_start_time: new_setup_start_time,
        setup_end_time: new_setup_end_time,
        breakdown_start_time: new_breakdown_start_time,
        breakdown_end_time: new_breakdown_end_time
      )

      # Recursively update the dependent item's dependencies
      update_time_dependencies(dependent_item, {
                                 setup_start_time: dependent_item.setup_start_time - setup_start_time_diff,
                                 setup_end_time: dependent_item.setup_end_time - setup_end_time_diff,
                                 breakdown_start_time: dependent_item.breakdown_start_time - breakdown_start_time_diff,
                                 breakdown_end_time: dependent_item.breakdown_end_time - breakdown_end_time_diff
                               }, {
                                 setup_start_time: new_setup_start_time,
                                 setup_end_time: new_setup_end_time,
                                 breakdown_start_time: new_breakdown_start_time,
                                 breakdown_end_time: new_breakdown_end_time
                               }, visited)
    end
  end
end
