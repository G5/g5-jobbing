module G5::Jobbing::AccessToken
  def get_access_token
    @access_token ||= G5AuthenticationClient::Client.new.get_access_token
  end
end