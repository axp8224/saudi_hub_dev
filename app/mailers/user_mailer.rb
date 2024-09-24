class UserMailer < ApplicationMailer
  default from: 'donghatamu@tamu.edu'

  def virtual_welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Saudi Student Association!')
  end
end
