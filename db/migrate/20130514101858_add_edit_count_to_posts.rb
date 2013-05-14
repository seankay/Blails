class AddEditCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :edit_count, :integer, default: 0
  end
end
