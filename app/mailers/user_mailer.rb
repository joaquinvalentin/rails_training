# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = 'http://example.com/login'
    mail(from: params[:admin], to: @user, subject: 'Welcome to My Awesome Site')
  end
end
