# frozen_string_literal: true

# spec/jobs/application_job_spec.rb
require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  describe 'behaviour' do
    it 'inherits from ActiveJob::Base' do
      expect(ApplicationJob).to be < ActiveJob::Base
    end

    # You can add more test cases here to cover specific behaviors of ApplicationJob
  end
end
