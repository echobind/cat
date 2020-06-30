class AddDestinationClubhouseApiKeyToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :destination_clubhouse_api_token, :string
  end
end
