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

  def self.birthday_to(birthday, mdy)
    case mdy
    when :day
      regex = Regexp.new(/\-\w*\z/)
    when :month
      regex = Regexp.new(/\-\w*\-/)
    when :year
      regex = Regexp.new(/^\w*\-/)
    end
    if birthday.is_a?(String)
      birthday.scan(regex).first.gsub("-","").to_i
    end
  end

  def self.my_profile?(user, current_user)
    user == current_user
  end

end