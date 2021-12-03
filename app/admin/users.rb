# frozen_string_literal: true

ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :password, :admin

  before_action :remove_password_params_if_blank, only: [:update]
  controller do
    def remove_password_params_if_blank
      return unless params[:user][:password].blank? && params[:user][:password_confirmation].blank?

      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
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
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :password_digest, :admin]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
