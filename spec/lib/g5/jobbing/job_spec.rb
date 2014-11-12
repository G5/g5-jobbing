require 'spec_helper'

describe G5::Jobbing::Job do
  let(:uid) { 'uid' }
  let(:urn) { 'urn' }
  let(:state) { 'state' }
  let(:integration_setting_uid) { 'isuid' }
  let(:message) { 'message' }
  let(:created_at) { DateTime.new(2012, 11, 11) }
  let(:updated_at) { DateTime.new(2013, 10, 10) }

  subject { G5::Jobbing::Job.new(uid:                     uid, urn: urn, state: state,
                                 integration_setting_uid: integration_setting_uid,
                                 message:                 message, created_at: created_at, updated_at: updated_at) }

  its(:uid) { is_expected.to eq(uid) }
  its(:urn) { is_expected.to eq(urn) }
  its(:state) { is_expected.to eq(state) }
  its(:integration_setting_uid) { is_expected.to eq(integration_setting_uid) }
  its(:message) { is_expected.to eq(message) }
  its(:created_at) { is_expected.to eq(created_at) }
  its(:updated_at) { is_expected.to eq(updated_at) }

  describe 'logs_url' do
    subject { G5::Jobbing::Job.new(urn: 3) }

    context 'LOGS_BY_JOB_URL set' do
      it 'generates proper url' do
        expect(subject).to receive(:logs_by_job_url).at_least(:once).and_return('http://splunk.com?external_id={{JOB_ID}}')
        expect(subject.logs_url).to eq('http://splunk.com?external_id=3')
      end
    end

    context 'LOGS_BY_JOB_URL NOT set' do
      it 'generates proper url' do
        expect(subject).to receive(:logs_by_job_url).and_return(nil)
        expect(subject.logs_url).to eq('ENV[LOGS_BY_JOB_URL] not set!')
      end
    end
  end
end