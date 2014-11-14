class G5::Jobbing::JobStatRetriever
  include G5::Jobbing::JobFetcher

  attr_accessor :rollup_by

  def initialize(params={})
    self.rollup_by = params[:rollup_by]
  end

  def perform

  end
end