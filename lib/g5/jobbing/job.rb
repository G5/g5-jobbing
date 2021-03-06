class G5::Jobbing::Job
  include Virtus.model

  attribute :uid, String
  attribute :urn, String
  attribute :state, String
  attribute :created_at, DateTime
  attribute :updated_at, DateTime
  attribute :location_setting_uid, String
  attribute :location_setting_urn, String
  attribute :message, String
  attribute :error_state, Boolean
  attribute :success_state, Boolean
  attribute :location_jobs_failing, Boolean, default: false

  def logs_url
    return 'ENV[LOGS_BY_JOB_URL] not set!' if logs_by_job_url.blank?
    logs_by_job_url.gsub('{{JOB_ID}}', "#{self.urn}")
  end

  def logs_by_job_url
    ENV['LOGS_BY_JOB_URL']
  end
end
