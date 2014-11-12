class G5::Jobbing::JobRetriever
  include G5::Jobbing::AccessToken
  attr_accessor :locations_integration_setting_uids

  def initialize(params={})
    self.locations_integration_setting_uids = params[:locations_integration_setting_uids]
  end

  def perform
    response = HTTParty.get(jobs_url_for_locations,
                            {query:   {access_token: get_access_token},
                             headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    )
    JSON.parse(response.body)['jobs'].collect { |job_hash| G5::Jobbing::Job.new(job_hash) }
  end

  def jobs_url_for_locations
    "#{ENV['JOBS_URL']}/api/v1/jobs?current=true&integration_setting_uid=#{CGI.escape(locations_as_parameter)}"
  end

  def locations_as_parameter
    "[#{self.locations_integration_setting_uids.join(',')}]"
  end
end