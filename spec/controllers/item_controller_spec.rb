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
    it 'destroys the requested item' do
      expect do
        delete :destroy, params: { id: item3.id }, format: :json
      end.to change(Item, :count).by(-1)
    end

    it 'returns a no content status' do
      delete :destroy, params: { id: item3.id }, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end
end
