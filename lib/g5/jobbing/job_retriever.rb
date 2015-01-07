class G5::Jobbing::JobRetriever
  include G5::Jobbing::JobFetcher
  attr_accessor :location_setting_urns

  def initialize(params={})
    self.location_setting_urns = params[:location_setting_urns]
  end

  def current
    fetch_get jobs_url_for_locations
  end

  def perform
    warn "[DEPRECATION] `perform` is deprecated. Please use `current` instead."
    current
  end

  def latest_successful
    query_options = {
      state: "completed_with_no_errors",
      location_setting_urn: locations_as_parameter,
      distinct_attr: "location_setting_urn"
    }

    fetch_get(jobs_base_url, query_options)
  end

  def jobs_url_for_locations
    "#{jobs_base_url}?current=true&location_setting_urn=#{locations_as_parameter}"
  end

  def locations_as_parameter
    "[#{self.location_setting_urns.join(',')}]"
  end
end
