require 'spec_helper'

describe G5::Jobbing::JobStat do
  let(:rolled_up_by) { 'rolled up by' }
  let(:jobs) { [G5::Jobbing::Job.new(error_state: true, message: 'you dun screwed up son'),
                G5::Jobbing::Job.new(error_state: false),
                G5::Jobbing::Job.new(error_state: true, message: 'boom'),] }

  subject { G5::Jobbing::JobStat.new(rolled_up_by: rolled_up_by, jobs: jobs) }

  its(:rolled_up_by) { is_expected.to eq(rolled_up_by) }
  its(:jobs) { is_expected.to eq(jobs) }
  its(:error_count) { is_expected.to eq(2) }
  its(:error_messages) { is_expected.to eq(['you dun screwed up son', 'boom']) }
end