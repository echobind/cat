class AddApiTokenFieldToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :clubhouse_api_token, :string
  end
end
