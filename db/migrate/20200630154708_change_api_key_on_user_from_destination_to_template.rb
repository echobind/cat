class ChangeApiKeyOnUserFromDestinationToTemplate < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :clubhouse_api_token, :template_clubhouse_api_token
  end
end
