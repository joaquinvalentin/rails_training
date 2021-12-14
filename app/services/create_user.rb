# frozen_string_literal: true

class CreateUser < ServiceObject
  attr_reader :user, :error

  def initialize(*args)
    super()
    @user_params = args[0][:user_params]
    @creator = args[0][:creator]
    @error = false
  end

  def call
    @status = :error
    @user = User.new(@user_params)

    return @error_code = 4106 if User.find_by_email(@user_params[:email])
    return @error_code = 4103 unless UserPolicy.new(@creator, @user).create?

    return @error_code = 4104 unless @user.valid?

    create_user
    send_email
    @status = :success
  end

  private

  def create_user
    @user.save!
  end

  def send_email
    UserMailer.with(user: @user, admin: @creator).welcome_email.deliver_now
  end
end
