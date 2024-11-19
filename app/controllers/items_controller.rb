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
  
    # Assign dependencies if present
    if params[:item][:dependencies].present?
      dependency_ids = params[:item][:dependencies].map(&:to_i)
      dependency_items = Item.where(id: dependency_ids)
  
      # Update the item attributes first
      if @item.update(item_params.except(:dependencies)) # Ensure dependencies are excluded
        # Assign dependencies to the item
        @item.dependencies = dependency_items
  
        if @item.save
          render json: { status: 'success', item: @item }, status: :ok
        else
          render json: { status: 'error', message: @item.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { status: 'error', message: @item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # No dependencies provided, just update the item normally
      if @item.update(item_params)
        render json: { status: 'success', item: @item }, status: :ok
      else
        render json: { status: 'error', message: @item.errors.full_messages }, status: :unprocessable_entity
      end
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
      render json: { message: 'Item successfully deleted' }, status: :ok
    else
      render json: { error: 'Failed to delete item' }, status: :unprocessable_entity
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
