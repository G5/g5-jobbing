class G5::Jobbing::JobStarter
  include G5::Jobbing::AccessToken
  attr_accessor :locations_integration_setting_uid

  def initialize(params={})
    self.locations_integration_setting_uid = params[:locations_integration_setting_uid]
  end

  def perform
    response = HTTParty.post(start_job_url,
                             {query:   {access_token: get_access_token},
                              headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    )
    201 == response.code
  end

  def start_job_url
    "#{ENV['JOBS_URL']}/api/v1/job_runners?integration_setting_uid=#{CGI.escape(self.locations_integration_setting_uid)}"
  end
end