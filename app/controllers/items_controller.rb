# frozen_string_literal: true

# ItemsController handles the CRUD actions for items, including creation,
# updating, deletion, and searching for items by step_id.
class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  # POST /items or /items.json
  def create
    #Rails.logger.debug "Received dependencies: #{params[:item][:dependencies]}" 
    Rails.logger.debug "Item params: #{item_params.inspect}"
    puts "Item params: #{item_params.inspect}" # Use puts for direct output if logging isn't working

    #@item = Item.new(item_params)
    @item = Item.new(item_params.except(:dependencies))

    if @item.save
      if params[:item][:dependencies].present?
        Rails.logger.debug("Dependencies: #{params[:item][:dependencies].inspect}") # anprasa
        #@item.dependencies = Item.find(params[:item][:dependencies])
        #@item.dependencies = Item.where(id: params[:item][:dependencies])
        # dependencies = Item.where(id: params[:item][:dependencies].map(&:to_i))
        # @item.dependencies = dependencies
        #dependency_ids = params[:item][:dependencies].map { |id| id.to_i }
        dependency_ids = params[:item][:dependencies].map(&:to_i)
        #Rails.logger.debug "Converted dependency IDs: #{dependency_ids}" 
        puts "Converted dependency IDs: #{dependency_ids}" # anprasa
        dependencies = Item.where(id: dependency_ids)
        #Rails.logger.debug "Fetched dependencies: #{dependencies.inspect}" 
        puts "Fetched dependencies: #{dependencies.inspect}" # anprasa

      
        # Assign the dependencies
        @item.dependencies = dependencies
        #params[:item][:dependencies].each do |dependency_id|
          #ItemDependency.create(item_id: @item.id, dependent_item_id: dependency_id)
        #end
      end
      render json: @item, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # Fetch dependencies for a specific item
  def dependencies
    @item = Item.find(params[:id])
    #@dependencies = @item.dependencies
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

  # def items_by_step
  #   step_id = params[:step_id]
  #   @items = Item.where(step_id: step_id)  # Adjust this to match your model structure
  #   render json: @items
  # end

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
