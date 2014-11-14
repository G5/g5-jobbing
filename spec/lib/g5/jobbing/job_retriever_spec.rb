require 'spec_helper'

describe G5::Jobbing::JobRetriever do
  let!(:locations_integration_setting_urn_1) { 'urn1' }
  let!(:locations_integration_setting_urn_2) { 'urn2' }

  subject { G5::Jobbing::JobRetriever.new(location_setting_urns: [locations_integration_setting_urn_1, locations_integration_setting_urn_2]) }

  describe :perform do
    let(:body) { fixture('jobs.json') }
    let(:token) { 'the toke' }
    before do
      expect(G5AuthenticationClient::Client).to receive(:new).and_return(double(:token, get_access_token: token))
      expect(HTTParty).to receive(:get).with(subject.jobs_url_for_locations,
                                             {query:   {access_token: token},
                                              headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'}}).
                              and_return(double(:response, body: body))
    end
    it 'returns array of jobs' do
      result = subject.perform
      expect(result.length).to eq(2)
      expect(result.all? { |job| G5::Jobbing::Job == job.class }).to be_truthy
      expect(result.collect(&:integration_setting_uid)).to eq(%w(http://localhost/clients/g5-c-6i4h3un-ethan-bode/locations/g5-cl-6i4h3uo-zoe-krajcik/locations_integration_settings/g5-lis-6i4h3uo http://localhost/clients/g5-c-6i4h3un-ethan-bode/locations/g5-cl-6i4h3un-retha-hane/locations_integration_settings/g5-lis-6i4h3un))
      expect(result.collect(&:error_state)).to eq([true, false])
      expect(result.collect(&:success_state)).to eq([false, true])
    end
  end

  its (:locations_as_parameter) { is_expected.to eq("[#{locations_integration_setting_urn_1},#{locations_integration_setting_urn_2}]") }

  describe :jobs_url_for_locations do
    it 'filters by current and locations_integration_setting UIDs' do
      expect(subject).to receive(:locations_as_parameter).and_return('loc_param')
      expect(subject.jobs_url_for_locations).to match(/\/api\/v1\/jobs\?current=true&integration_setting_urn=loc_param/)
    end
  end
end