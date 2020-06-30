class KeysController < ApplicationController
    # puts('fewfew', current_user)

    before_action :check_authentication, only: [:index]

    def check_authentication
        unless current_user
        flash[:notice] = "This page is not available"
        redirect_to root_path
        end
    end

    def index
        @current_user = current_user
        render "keys/index"
    end

    def set_template_workspace_api_key
      current_user.update_attribute(:template_clubhouse_api_token, params["template_workspace_api_key"])
  
      redirect_to keys_url
    end
  
    def delete_template_workspace_api_key
      current_user.update_attribute(:template_clubhouse_api_token, nil)
  
      redirect_to keys_url
    end

    def set_destination_workspace_api_key
      current_user.update_attribute(:destination_clubhouse_api_token, params["destination_workspace_api_key"])
  
      redirect_to keys_url
    end

    def delete_destination_workspace_api_key
      current_user.update_attribute(:destination_clubhouse_api_token, nil)
  
      redirect_to keys_url
    end
  end
  