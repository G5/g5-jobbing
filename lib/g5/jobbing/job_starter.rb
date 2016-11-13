class G5::Jobbing::JobStarter
  attr_accessor :location_setting_urn, :access_token

  def initialize(params={})
    self.location_setting_urn = params[:location_setting_urn]
    self.access_token = params[:access_token]
  end

  def perform
    response = HTTParty.post(start_job_url,
                 {
                   query: { access_token: access_token },
                   headers: {
                     'Content-Type' => 'application/json',
                     'Accept' => 'application/json'
                   }
                 }
               )
    201 == response.code
  end

  def start_job_url
    "#{ENV['JOBS_URL']}/api/v1/job_runners?location_setting_urn=#{self.location_setting_urn}"
  end
end
