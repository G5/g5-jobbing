require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/blank'
require 'g5/jobbing/version'
require 'g5_authentication_client'
require 'httparty'
require 'virtus'

module G5
  module Jobbing

  end
end

require 'g5/jobbing/access_token'
require 'g5/jobbing/job_fetcher'
require 'g5/jobbing/job'
require 'g5/jobbing/job_stat'
require 'g5/jobbing/job_retriever'
require 'g5/jobbing/job_starter'
require 'g5/jobbing/job_stat_retriever'
