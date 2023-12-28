class AddFeatureToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :feature, :text
  end
end
