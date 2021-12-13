# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email
    @user_email = params[:user]
    @url = 'http://example.com/login'
    mail(from: params[:admin], to: @user_email, subject: 'Welcome to My Awesome Site')
  end
end
