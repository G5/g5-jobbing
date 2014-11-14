class G5::Jobbing::JobStat
  include Virtus.model

  attribute :rolled_up_by, String
  attribute :jobs, Array

  def error_count
    self.jobs.count { |job| job.error_state }
  end

  def error_messages
    self.jobs.collect { |job| job.message }.compact
  end
end