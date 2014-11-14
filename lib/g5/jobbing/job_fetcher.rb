module G5::Jobbing::JobFetcher
  include G5::Jobbing::AccessToken

  def fetch_get(url)
    response = HTTParty.get(url,
                            {query:   {access_token: get_access_token},
                             headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    )
    job_hashes = JSON.parse(response.body)['jobs']
    job_hashes.collect { |job_hash| G5::Jobbing::Job.new(job_hash) }
  end

  def jobs_base_url
    "#{ENV['JOBS_URL']}/api/v1/jobs"
  end
end