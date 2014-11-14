class G5::Jobbing::JobRetriever
  include G5::Jobbing::JobFetcher
  attr_accessor :location_setting_urns

  def initialize(params={})
    self.location_setting_urns = params[:location_setting_urns]
  end

  def perform
    fetch_get jobs_url_for_locations
  end

  def jobs_url_for_locations
    "#{jobs_base_url}?current=true&integration_setting_urn=#{locations_as_parameter}"
  end

  def locations_as_parameter
    "[#{self.location_setting_urns.join(',')}]"
  end
end