# frozen_string_literal: true

require 'test_helper'

class PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plan = plans(:one)
  end

  test 'should get index' do
    get plans_url
    assert_response :success
  end

  test 'should get new' do
    get new_plan_url
    assert_response :success
  end

  test 'should create plan' do
    assert_difference('Plan.count') do
      post plans_url,
           params: { plan: { name: @plan.name, owner: @plan.owner, venue_length: @plan.venue_length,
                             venue_width: @plan.venue_width } }
    end

    assert_redirected_to plan_url(Plan.last)
  end

  test 'should show plan' do
    get plan_url(@plan)
    assert_response :success
  end

  test 'should get edit' do
    get edit_plan_url(@plan)
    assert_response :success
  end

  test 'should update plan' do
    patch plan_url(@plan),
          params: { plan: { name: @plan.name, owner: @plan.owner, venue_length: @plan.venue_length,
                            venue_width: @plan.venue_width } }
    assert_redirected_to plan_url(@plan)
  end

  test 'should destroy plan' do
    assert_difference('Plan.count', -1) do
      delete plan_url(@plan)
    end

    assert_redirected_to plans_url
  end
end
