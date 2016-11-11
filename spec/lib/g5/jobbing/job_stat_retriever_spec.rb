require 'spec_helper'

describe G5::Jobbing::JobStatRetriever do
  describe 'perform' do
    let(:body) { fixture('all-jobs.json') }
    let(:body_hash) { JSON.parse(body)['jobs'] }
    let(:foo_error_messages) do
      [
        body_hash.detect do |hash|
          hash['urn'] == 'g5-job-1t1slmdz'
        end['message']
      ]
    end
    let(:bar_error_messages) do
      [
        body_hash.detect do |hash|
          hash['urn'] == 'g5-job-1t1schlp'
        end['message']
      ]
    end
    let(:access_token) { "access_token" }
    let(:job_stat_retriever) do
      G5::Jobbing::JobStatRetriever.new(
        rollup_by: roll_up_by,
        access_token: access_token
      )
    end

    before do
      expect(HTTParty).to receive(:get)
        .with("#{job_stat_retriever.jobs_base_url}?current=true",
          {
            query: { access_token: access_token },
            headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json'
            }
          }
        )
        .and_return(double(:response, body: body))
    end

    let(:roll_up_by) do
      {
        foo: %w(g5-lis-1t0thzui g5-lis-1t0thj3p),
        no_matches: ['madeup'],
        bar: %w(g5-lis-1 g5-lis-1t0n85r2 g5-lis-1t0tf3u0)
      }
    end

    subject { job_stat_retriever.perform }

    its(:keys) { is_expected.to eq([:foo, :bar]) }

    it 'rolls up foo' do
      expect(subject[:foo].jobs.count).to eq(2)
      expect(subject[:foo].error_count).to eq(1)
      expect(subject[:foo].error_messages).to eq(foo_error_messages)
    end

    it 'rolls up bar' do
      expect(subject[:bar].jobs.count).to eq(3)
      expect(subject[:bar].error_count).to eq(1)
      expect(subject[:bar].error_messages).to eq(bar_error_messages)
    end

    it 'has no no_matches' do
      expect(subject[:no_matches]).to be_nil
    end
  end
end
