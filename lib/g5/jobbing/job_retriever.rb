class G5::Jobbing::JobRetriever
  include G5::Jobbing::JobFetcher
  attr_accessor :location_setting_urns

  def initialize(params={})
    self.location_setting_urns = params[:location_setting_urns]
  end

  def perform
    response = fetch_get jobs_url_for_locations

    response.collect { |job_hash| G5::Jobbing::Job.new(job_hash) }
  end

  def jobs_url_for_locations
    "#{jobs_base_url}?current=true&integration_setting_urn=#{locations_as_parameter}"
  end

  def locations_as_parameter
    "[#{self.location_setting_urns.join(',')}]"
  end
end