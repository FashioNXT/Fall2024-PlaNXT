# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let!(:plan) do
    Plan.create!(name: 'Test1', owner: 'Morris', venue_length: 100, venue_width: 100)
  end

  before do
    plan.steps.create!(
      start_date: '2021-04-01',
      start_time: '2021-04-01 10:00:00',
      end_time: '2021-04-01 11:00:00',
      break1_start_time: '2021-04-01 10:30:00',
      break1_end_time: '2021-04-01 10:45:00',
      break2_start_time: '2021-04-01 10:30:00',
      break2_end_time: '2021-04-01 10:45:00'
    )

    plan.steps.create!(
      start_date: '2021-08-01',
      start_time: '2021-08-01 10:00:00',
      end_time: '2021-08-01 11:00:00',
      break1_start_time: '2021-08-01 10:30:00',
      break1_end_time: '2021-08-01 10:45:00',
      break2_start_time: '2021-08-01 10:30:00',
      break2_end_time: '2021-08-01 10:45:00'
    )
  end

  let!(:item1) do
    Item.create!(
      name: 'item-1',
      model: 'Chair',
      width: 100,
      length: 100,
      depth: 100,
      rotation: 100,
      description: 'Test',
      xpos: 100,
      ypos: 100,
      zpos: 100,
      step_id: plan.steps.first.id
    )
  end

  let!(:item2) do
    Item.create!(
      name: 'item-2',
      model: 'Chair',
      width: 100,
      length: 100,
      depth: 100,
      rotation: 100,
      description: 'Test',
      xpos: 100,
      ypos: 100,
      zpos: 100,
      step_id: plan.steps.first.id
    )
  end

  let!(:item3) do
    Item.create!(
      name: 'item-3',
      model: 'Chair',
      width: 100,
      length: 100,
      depth: 100,
      rotation: 100,
      description: 'Test',
      xpos: 100,
      ypos: 100,
      zpos: 100,
      step_id: plan.steps.last.id
    )
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'returns all items as JSON' do
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq(3)
    end
  end

  describe 'when trying to add the item to the step' do
    context 'with valid parameters' do
      it 'add the item to the database' do
        post :create,
             params: { item: { name: 'item-4', model: 'Chair', width: 100, length: 100, depth: 100, rotation: 100,
                               description: 'Test', xpos: 100, ypos: 100, zpos: 100, step_id: plan.steps.last.id } }, format: :json

        item = Item.last
        expect(item.name).to eq('item-4')
        expect(item.model).to eq('Chair')
        expect(item.width).to eq(100)
        expect(item.length).to eq(100)
        expect(item.depth).to eq(100)
        expect(item.rotation).to eq(100)
        expect(item.description).to eq('Test')
        expect(item.xpos).to eq(100)
        expect(item.ypos).to eq(100)
        expect(item.zpos).to eq(100)
        expect(item.step_id).to eq(plan.steps.last.id)
      end

      it 'returns a status code of ok' do
        post :create,
             params: { item: { name: 'item-4', model: 'Chair', width: 100, length: 100, depth: 100, rotation: 100,
                               description: 'Test', xpos: 100, ypos: 100, zpos: 100, step_id: plan.steps.last.id } }, format: :json
        Item.last

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: nil, model: 'Chair', width: 100, length: 100, depth: 100 } }

      it 'does not create a new Item' do
        expect do
          post :create, params: { item: invalid_attributes }, format: :json
        end.not_to change(Item, :count)
      end

      it 'returns a status code of unprocessable_entity' do
        post :create, params: { item: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'when trying to search the item with step id' do
    before do
      step_id = plan.steps.first.id
      get :search, params: { step_id: }, format: :json
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct items as JSON' do
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2) # Expecting 2 items from step1
    end
  end

  describe 'when we want to update a item' do
    it 'updates the item' do
      put :update, params: {
        id: item1.id,
        item: {
          name: 'item-1',
          model: 'Blue-Chair'
        }
      }
      item1.reload
      expect(item1.name).to eq('item-1')
      expect(item1.model).to eq('Blue-Chair')
      expect(response).to have_http_status(:ok)
    end
  end

  # describe "when we want to delete a item" do
  describe 'DELETE #destroy' do
    let!(:item3) { create(:item) }

    it 'destroys the requested item' do
      expect do
        delete :destroy, params: { id: item3.id }, format: :json
      end.to change(Item, :count).by(-1)
    end

    it 'returns a success message and status ok' do
      delete :destroy, params: { id: item3.id }, format: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'message' => 'Item successfully deleted' })
    end

    it 'returns an error message when deletion fails' do
      allow_any_instance_of(Item).to receive(:destroy).and_return(false)

      delete :destroy, params: { id: item3.id }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Failed to delete item' })
    end
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'returns all items as JSON' do
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq(3)
    end
  end

  describe 'POST #create' do
    # let(:valid_attributes) { { name: "Test Item", dependencies: [] } }
    # let(:invalid_attributes) { { name: nil, dependencies: [] } }
    # let!(:dependency_item1) { Item.create(name: "Dependency 1") }
    # let!(:dependency_item2) { Item.create(name: "Dependency 2") }

    # post :create,
    #          params: { item: { name: 'item-4', model: 'Chair', width: 100, length: 100, depth: 100, rotation: 100,
    #                            description: 'Test', xpos: 100, ypos: 100, zpos: 100, step_id: plan.steps.last.id } }, format: :json

    context 'with valid attributes and no dependencies' do
      it 'creates a new item and returns status :ok' do
        post :create,
             params: { item: { name: 'item-5', model: 'Chair', width: 100, length: 100, depth: 100, rotation: 100,
                               description: 'Test', xpos: 100, ypos: 100, zpos: 100, step_id: plan.steps.last.id } }, format: :json
        expect(response).to have_http_status(:ok)
        item = Item.last
        expect(JSON.parse(response.body)['name']).to eq('item-5')
        expect(item.model).to eq('Chair')
        expect(item.width).to eq(100)
      end
    end

    context 'with valid attributes and dependencies' do
      it 'creates a new item with assigned dependencies and returns status :ok' do
        last_created = Item.last
        post :create,
             params: { item: { name: 'item-5', model: 'Chair', width: 100, length: 100, depth: 100, rotation: 100,
                               description: 'Test', xpos: 100, ypos: 100, zpos: 100,
                               step_id: plan.steps.last.id, dependencies: [last_created.id] } }, format: :json
        expect(response).to have_http_status(:ok)
        created_item = Item.last
        expect(created_item.dependencies).to match_array([last_created])
      end
    end
  end

  describe 'GET #dependencies' do
    let!(:item) do
      Item.create(
        name: 'item-6', model: 'Chair', width: 100, length: 100, depth: 100,
        rotation: 100, description: 'Test', xpos: 100, ypos: 100,
        zpos: 100, step_id: plan.steps.last.id
      )
    end

    let!(:dependency1) do
      Item.create(
        name: 'item-7', model: 'Table', width: 50, length: 50, depth: 50,
        rotation: 0,
        description: 'First dependency', xpos: 0, ypos: 0,
        zpos: 0, step_id: plan.steps.last.id
      )
    end

    let!(:dependency2) do
      Item.create(
        name: 'item-8', model: 'Camera', width: 10, length: 10,
        depth: 30, rotation: 0,
        description: 'Second dependency', xpos: 10, ypos: 10,
        zpos: 10, step_id: plan.steps.last.id
      )
    end

    before do
      # Associate dependencies with the item
      item.dependencies << [dependency1, dependency2]
    end

    context 'when the item exists and has dependencies' do
      it 'returns the dependencies as JSON with id and name' do
        get :dependencies, params: { id: item.id }, format: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        # Check the response contains the correct dependencies
        expect(json_response).to be_an(Array)
        expect(json_response.size).to eq(2)

        expect(json_response).to include(
          { 'id' => dependency1.id, 'name' => dependency1.name },
          { 'id' => dependency2.id, 'name' => dependency2.name }
        )
      end
    end
    describe 'PATCH/PUT #update' do
      let(:valid_attributes) do
        {
          name: 'Updated Item',
          model: 'Updated Model',
          width: 150,
          length: 150,
          depth: 150,
          rotation: 45,
          description: 'Updated description',
          xpos: 200,
          ypos: 200,
          zpos: 200,
          step_id: plan.steps.first.id
        }
      end

      let(:invalid_attributes) do
        {
          name: nil,
          model: 'Invalid Model'
        }
      end

      context 'with valid attributes' do
        it 'updates the item and dependencies' do
          put :update, params: {
            id: item1.id,
            item: valid_attributes.merge(dependencies: [item2.id])
          }, format: :json

          item1.reload
          expect(item1.name).to eq('Updated Item')
          expect(item1.model).to eq('Updated Model')
          expect(item1.dependencies).to include(item2)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'without dependencies' do
        it 'updates the item without adding dependencies' do
          put :update, params: {
            id: item1.id,
            item: valid_attributes
          }, format: :json

          item1.reload
          expect(item1.dependencies).to be_empty
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when dependencies are updated' do
        it 'replaces the dependencies' do
          item1.dependencies = [item2]
          item1.save

          put :update, params: {
            id: item1.id,
            item: valid_attributes.merge(dependencies: [item3.id])
          }, format: :json

          item1.reload
          expect(item1.dependencies).to eq([item3])
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
