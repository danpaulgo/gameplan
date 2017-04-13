class UserHelper

  def self.current_user(session)
    User.find(session[:id]) if session[:id]
  end

  def self.logged_in?(session)
    !!current_user(session)
  end

  def self.months
    ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  end

  def self.birthday_to(birthday, timespan)
    case timespan
    when :day
      regex = Regexp.new(/^\w*\//)
    when :month
      regex = Regexp.new(/^\w*\//)
    when :year
      regex = Regexp.new(/\/\w*\z/)
    end
    if birthday.is_a?(String)
      birthday.scan(regex).first.gsub("/","").to_i
    end
  end

end