require 'spec_helper'

describe G5::Jobbing::JobStarter do
  let(:location_setting_urn) { "location_setting_urn" }
  let(:access_token) { "12345" }

  subject do
    G5::Jobbing::JobStarter.new(
      location_setting_urn: location_setting_urn,
      access_token: access_token,
    )
  end

  describe :perform do
    before do
      expect(HTTParty).to receive(:post).with(
        subject.start_job_url,
        {
          query: {
            access_token: access_token
          },
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          }
        }
      ).and_return(double(:response, code: code))
    end

    describe 'success' do
      let(:code) { 201 }
      its(:perform) { is_expected.to eq true }
    end

    describe 'failure' do
      let(:code) { 404 }
      its(:perform) { is_expected.to eq false }
    end
  end

  its(:start_job_url) { is_expected.to match(/\/api\/v1\/job_runners\?location_setting_urn=#{location_setting_urn}/) }
end
