class G5::Jobbing::JobRetriever
  include G5::Jobbing::AccessToken
  attr_accessor :location_setting_urns

  def initialize(params={})
    self.location_setting_urns = params[:location_setting_urns]
  end

  def perform
    response = HTTParty.get(jobs_url_for_locations,
                            {query:   {access_token: get_access_token},
                             headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    )
    JSON.parse(response.body)['jobs'].collect { |job_hash| G5::Jobbing::Job.new(job_hash) }
  end

  def jobs_url_for_locations
    "#{ENV['JOBS_URL']}/api/v1/jobs?current=true&integration_setting_urn=#{CGI.escape(locations_as_parameter)}"
  end

  def locations_as_parameter
    "[#{self.location_setting_urns.join(',')}]"
  end
end