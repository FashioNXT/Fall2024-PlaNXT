# frozen_string_literal: true

require 'application_system_test_case'

class StepsTest < ApplicationSystemTestCase
  setup do
    @step = steps(:one)
  end

  test 'visiting the index' do
    visit steps_url
    assert_selector 'h1', text: 'Steps'
  end

  test 'should create step' do
    visit steps_url
    click_on 'New step'

    fill_in 'Break1 end time', with: @step.break1_end_time
    fill_in 'Break1 start time', with: @step.break1_start_time
    fill_in 'Break2 end time', with: @step.break2_end_time
    fill_in 'Break2 start time', with: @step.break2_start_time
    fill_in 'End time', with: @step.end_time
    fill_in 'Plan', with: @step.plan_id
    fill_in 'Start date', with: @step.start_date
    fill_in 'Start time', with: @step.start_time
    click_on 'Create Step'

    assert_text 'Step was successfully created'
    click_on 'Back'
  end

  test 'should update Step' do
    visit step_url(@step)
    click_on 'Edit this step', match: :first

    fill_in 'Break1 end time', with: @step.break1_end_time
    fill_in 'Break1 start time', with: @step.break1_start_time
    fill_in 'Break2 end time', with: @step.break2_end_time
    fill_in 'Break2 start time', with: @step.break2_start_time
    fill_in 'End time', with: @step.end_time
    fill_in 'Plan', with: @step.plan_id
    fill_in 'Start date', with: @step.start_date
    fill_in 'Start time', with: @step.start_time
    click_on 'Update Step'

    assert_text 'Step was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Step' do
    visit step_url(@step)
    click_on 'Destroy this step', match: :first

    assert_text 'Step was successfully destroyed'
  end
end
