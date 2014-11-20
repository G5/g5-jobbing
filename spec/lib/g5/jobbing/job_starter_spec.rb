require 'spec_helper'

describe G5::Jobbing::JobStarter do
  let(:location_setting_urn) { 'a-urn' }
  let(:token) { 'the toke' }
  subject { G5::Jobbing::JobStarter.new(location_setting_urn: location_setting_urn) }

  describe :perform do
    before do
      expect(G5AuthenticationClient::Client).to receive(:new).and_return(double(:token, get_access_token: token))
      expect(HTTParty).to receive(:post).with(subject.start_job_url,
                                              {query:   {access_token: token},
                                               headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'}}).
                              and_return(double(:response, code: code))
    end
    describe 'success' do
      let(:code) { 201 }
      its(:perform) { is_expected.to be_truthy }
    end

    describe 'failure' do
      let(:code) { 404 }
      its(:perform) { is_expected.to be_falsey }
    end
  end

  its(:start_job_url) { is_expected.to match(/\/api\/v1\/job_runners\?location_setting_urn=#{location_setting_urn}/) }
end