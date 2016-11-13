class G5::Jobbing::JobStatRetriever
  include G5::Jobbing::JobFetcher

  attr_accessor :rollup_by, :access_token

  def initialize(params={})
    self.rollup_by = params[:rollup_by]
    self.access_token = params[:access_token]
    @job_stats = Hash.new
  end

  def perform
    response = fetch_get("#{jobs_base_url}?current=true", {
      access_token: access_token
    })
    roll_it_up response
  end

  private
  def roll_it_up(jobs)
    jobs.each do |job|
      job_stat = find_matching_job_stat(job)
      job_stat.jobs << job if job_stat
    end
    @job_stats
  end

  def find_matching_job_stat(job)
    parent = self.rollup_by.detect { |key_values| key_values.last.include?(job.location_setting_urn) }.try(:first)
    return unless parent

    job_stat_key = @job_stats.keys.detect { |js_key| parent == js_key }
    return @job_stats[job_stat_key] if job_stat_key

    job_stat = G5::Jobbing::JobStat.new(rolled_up_by: parent, jobs: [])
    @job_stats[parent] = job_stat
    job_stat
  end
end
