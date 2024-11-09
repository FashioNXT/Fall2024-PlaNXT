# frozen_string_literal: true

class PlansController < ApplicationController
  require 'csv'

  before_action :set_plan, only: %i[show edit update destroy]

  before_action :require_user_logged_in!, unless: -> { !Rails.env.production? }

  # def user_plans
  #   @user = User.from_omniauth(request.env['omniauth.auth'])
  #   @plans = @user.plans
  # end

  # Method to upload an existing plan from a CSV file
  def upload_existing_plan
    # Process the uploaded file
    uploaded_file = params[:file]
    if uploaded_file.present? && uploaded_file.respond_to?(:read)
      file_contents = uploaded_file.read
      CSV.parse(file_contents, headers: true) do |row|
        # Extract plan attributes from the CSV row
        plan_attributes = row['Plan attributes'].split(', ')
        plan_params = {
          name: plan_attributes[1],
          owner: plan_attributes[2],
          venue_length: plan_attributes[3].to_f,
          venue_width: plan_attributes[4].to_f,
          timezone: plan_attributes[6]
        }
        @plan = Plan.new(plan_params)
        if @plan.save
          # Extract item attributes from the CSV row and associate them with the plan
          item_attributes = row['Item attributes'].split(', ')
          item_params = {
            name: item_attributes[1],
            model: item_attributes[2],
            width: item_attributes[3].to_f,
            length: item_attributes[5].to_f,
            depth: item_attributes[4].to_f,
            rotation: item_attributes[6].to_f,
            xpos: item_attributes[8].to_f,
            ypos: item_attributes[9].to_f,
            zpos: item_attributes[10].to_f,
            step_id: @plan.steps.first.id, # Assuming there's at least one step for each plan
            setup_start_time: Time.parse(item_attributes[13]),
            setup_end_time: Time.parse(item_attributes[14]),
            breakdown_start_time: Time.parse(item_attributes[15]),
            breakdown_end_time: Time.parse(item_attributes[16])
          }
          @plan.items.create(item_params)
        end
      end
      # Redirect to a different page upon successful file upload
      redirect_to plans_path, notice: 'File uploaded successfully.'
    else
      # Handle invalid file upload
      redirect_to plans_path, alert: 'Please upload a valid file.'
    end
  end

  def generate_floorplan(plan)
    # Extract plan dimensions
    plan.venue_length
    plan.venue_width

    # Extract item positions and dimensions
    items = plan.items
    items.map do |item|
      {
        name: item.name,
        model: item.model,
        xpos: item.xpos,
        ypos: item.ypos,
        zpos: item.zpos,
        width: item.width,
        length: item.length,
        depth: item.depth,
        rotation: item.rotation
      }
    end
  end

  layout 'layouts/empty', only: [:new]

  # GET /plans or /plans.json
  def index
    # @plans = Plan.all
    # Only display plans of the logged in user
    @plans = Plan.where(owner: session[:user_email])
  end

  # GET /plans/1 or /plans/1.json
  def show
    redirect_to edit_plan_path(@plan)
  end

  # GET /plans/new
  def new
    @plan = Plan.new
    @plan.steps.build # Build an empty Step associated with the new Plan
  end

  # GET /plans/1/edit
  def edit; end

  def floorplans2d
    @plan = Plan.find(params[:id])
    @venue_start = @plan.steps.first.start_time
    @venue_end = @plan.steps.first.end_time
  end

  def preview3d
    @plan = Plan.find(params[:id])

    scaler = 31.4
    json_content = JSON.parse(File.read(Rails.root.join('lib', 'design.room3d')))

    # Update timeline
    json_content['timeline'] = {
      'start_time' => @plan.steps.first.start_time,
      'end_time' => @plan.steps.first.end_time
    }

    # Update the corners of the floorplan
    json_content['floorplan']['corners'] = {
      '7922010e-f5f3-2e53-46f4-3819ea8cdc12' => {
        'x' => 0,
        'y' => 0
      },
      'a8b17dd7-026c-de11-3077-01a169d1b795' => {
        'x' => @plan.venue_width * scaler,
        'y' => 0
      },
      '8039b51e-5a0b-8843-3129-32e647a42002' => {
        'x' => 0,
        'y' => @plan.venue_length * scaler
      },
      '8a66d562-2eb4-2147-763c-7962e4208a0a' => {
        'x' => @plan.venue_width * scaler,
        'y' => @plan.venue_length * scaler
      }
    }

    # Add items to the floorplan
    @plan.steps.first.items.each do |item|
      json_content['items'].append({
                                     'item_name' => item.name,
                                     'model_url' => item.model,
                                     'xpos' => item.xpos * scaler,
                                     'ypos' => 0,
                                     'zpos' => item.zpos * scaler,
                                     'width' => item.width,
                                     'depth' => item.depth,
                                     'rotation' => item.rotation,
                                     'scale_x' => 1,
                                     'scale_y' => 1,
                                     'scale_z' => 1,
                                     'fixed' => false,
                                     'setup_start' => item.setup_start_time,
                                     'setup_end' => item.setup_end_time,
                                     'breakdown_start' => item.breakdown_start_time,
                                     'breakdown_end' => item.breakdown_end_time,
                                     'item_id' => item.id
                                   })
    end

    # Write the updated information to a JSON file stored in the public folder called "floorplan.json"
    File.write(Rails.root.join('public', 'floorplan.json'), JSON.pretty_generate(json_content))

    redirect_to blueprints_path
  end

  # POST /plans or /plans.json
  def create
    @plan = Plan.new(plan_params)
    respond_to do |format|
      if @plan.save
        format.html { redirect_to plans_path, notice: 'Plan was successfully created.' }
      else
        # If the plan cannot be saved due to invalid parameters, render the new template
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /plans/1 or /plans/1.json
  def update
    respond_to do |format|
      if update_plan_with_steps
        format.html { redirect_to plans_path, notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan }
      end
    end
  end

  def update_plan_with_steps
    return @plan.update(plan_params) if plan_params[:steps_attributes].nil?

    steps_attributes = plan_params[:steps_attributes].to_unsafe_h

    steps_attributes.each_value do |step_params|
      %i[start_time end_time break1_start_time break1_end_time break2_start_time break2_end_time].each do |attr|
        step_params[attr] = combine_date_and_time(step_params[:start_date], step_params[attr])
      end
    end

    @plan.update(plan_params.merge(steps_attributes:))
  end

  def combine_date_and_time(date, time)
    return nil if date.blank? || time.blank?

    DateTime.parse("#{date} #{time} #{Time.zone.now.strftime('%Z')}")
  end

  # DELETE /plans/1 or /plans/1.json
  def destroy
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Method to download all plan and item data as a CSV file
  def download_all_data
    @plans = Plan.includes(steps: :items).all

    # initiate a hash
    item_counts = Hash.new(0)

    # Generate CSV with plan and item data
    csv_data = CSV.generate(headers: true) do |csv|
      # Define headers
      csv << ['Plan ID', 'Plan Name', 'Venue Length', 'Venue Width', 'Plan Created At', 'Plan Updated At', 'Timezone',
              'Step ID', 'Step Start Time', 'Step End Time', 'Step Break1 Start Time', 'Step Break1 End Time', 'Step Break2 Start Time', 'Step Break2 End Time',
              'Item Name', 'Item Model', 'Item Width', 'Item Length', 'Item Depth', 'Item Rotation', 'Item X Position', 'Item Y Position', 'Item Z Position',
              'Item Setup Start Time', 'Item Setup End Time', 'Item Breakdown Start Time', 'Item Breakdown End Time']

      @plans.each do |plan|
        plan.steps.each do |step|
          step.items.each do |item|
            csv << [plan.id, plan.name, plan.venue_length, plan.venue_width, plan.created_at, plan.updated_at, plan.timezone,
                    step.id, step.start_time, step.end_time, step.break1_start_time, step.break1_end_time, step.break2_start_time, step.break2_end_time,
                    item.name, item.model, item.width, item.length, item.depth, item.rotation, item.xpos, item.ypos, item.zpos,
                    item.setup_start_time, item.setup_end_time, item.breakdown_start_time, item.breakdown_end_time]

            # summarize the amout of item
            item_counts[item.name] += 1
          end
        end
      end

      csv << []
      csv << ['Item Name', 'Count']
      item_counts.each do |name, count|
        csv << [name, count]
      end
    end

    send_data csv_data, filename: "plans_and_items_#{Date.today}.csv"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def plan_params
    # params.require(:plan).permit(:name, :owner, :venue_length, :venue_width, :user_email, steps_attributes: [:id, :start_date, :start_time, :end_time, :break1_start_time, :break1_end_time, :break2_start_time, :break2_end_time, :_destroy])
    params.require(:plan).permit(:name, :owner, :timezone, :venue_length, :venue_width,
                                 steps_attributes: %i[id start_date start_time end_time break1_start_time break1_end_time break2_start_time break2_end_time _destroy])
  end
end
