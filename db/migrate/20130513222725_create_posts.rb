class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title, null: false
      t.text :body, null: false
      t.boolean :private, default: true

      t.timestamps
    end
  end
end
