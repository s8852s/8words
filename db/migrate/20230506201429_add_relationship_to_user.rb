class AddRelationshipToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :relationship, :jsonb
    change_column :users, :notes, :text
  end
end
