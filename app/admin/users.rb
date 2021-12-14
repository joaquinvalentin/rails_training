# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :password, :admin

  before_action :remove_password_params_if_blank, only: [:update]
  controller do
    def remove_password_params_if_blank
      return unless params[:user][:password].blank? && params[:user][:password_confirmation].blank?

      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    def create
      CreateUser.call(user_params: params[:user].permit(:email, :password, :admin), creator: current_user)
    end
  end

  form do |f|
    f.inputs 'User Details' do
        f.input :email
        f.input :admin
        f.input :password
    end
    f.actions
  end
end
