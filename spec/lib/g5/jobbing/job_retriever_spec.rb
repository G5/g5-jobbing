require 'spec_helper'

describe G5::Jobbing::JobRetriever do
  let!(:locations_location_setting_urn_1) { 'urn1' }
  let!(:locations_location_setting_urn_2) { 'urn2' }

  let(:access_token) { 'access_token' }

  subject do
    G5::Jobbing::JobRetriever.new(
      location_setting_urns: [
        locations_location_setting_urn_1,
        locations_location_setting_urn_2
      ],
      access_token: access_token
    )
  end

  # TODO: convert to vcr
  describe '#current' do
    let(:body) { fixture('jobs.json') }
    before do
      expect(HTTParty).to receive(:get)
        .with(subject.jobs_url_for_locations,
          {
            query:   { access_token: access_token },
            headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json'
            }
          }
        )
        .and_return(double(:response, body: body))
    end
    it 'returns array of jobs' do
      result = subject.current
      expect(result.length).to eq(2)
      expect(result.all? do |job|
        G5::Jobbing::Job == job.class
      end).to eq true
      expect(result.collect(&:location_setting_uid)).to eq(
        %w(
          http://localhost/clients/g5-c-6i4h3un-ethan-bode/locations/g5-cl-6i4h3uo-zoe-krajcik/locations_integration_settings/g5-lis-6i4h3uo http://localhost/clients/g5-c-6i4h3un-ethan-bode/locations/g5-cl-6i4h3un-retha-hane/locations_integration_settings/g5-lis-6i4h3un
        )
      )
      expect(result.collect(&:error_state)).to eq([true, false])
      expect(result.collect(&:success_state)).to eq([false, true])
    end
  end

  its(:locations_as_parameter) do
    is_expected.to eq("["\
      "#{locations_location_setting_urn_1}," \
      "#{locations_location_setting_urn_2}]"
    )
  end

  describe '#jobs_url_for_locations' do
    it 'returns a url with current and locations_integration_setting UIDs' do
      expect(subject).to receive(:locations_as_parameter).and_return('loc_param')
      expect(subject.jobs_url_for_locations)
        .to match(/\/api\/v1\/jobs\?current=true&location_setting_urn=loc_param/)
    end
  end

  # TODO: convert to vcr
  describe '#latest_successful' do
    let(:body) { fixture('successful_jobs.json') }
    before do
      query_params = {
        state: "completed_with_no_errors",
        location_setting_urn: "loc_urn",
        distinct_attr: "location_setting_urn",
        access_token: access_token,
      }

      allow(subject).to receive(:jobs_base_url).and_return('api/v1/jobs')
      allow(subject).to receive(:locations_as_parameter).and_return('loc_urn')
      expect(HTTParty).
        to receive(:get).
        with(
          'api/v1/jobs',
          {
            query: query_params,
            headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json'
            }
          }
        ).and_return(double(:response, body: body))
    end

    it 'returns an array of the latest successful jobs of each location setting', vcr: {mode: :once} do
      result = subject.latest_successful
      expect(result.all? do |job|
        G5::Jobbing::Job == job.class
      end).to be true
    end
  end
end
