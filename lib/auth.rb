class Auth
  def self.call(username, password)
    return true if Rails.env.development?
    match_username = username.to_s == ENV['MTTRS_ADMIN_USERNAME'].to_s
    match_password = password.to_s == ENV['MTTRS_ADMIN_PASSWORD'].to_s
    match_username && match_password
  end
end
