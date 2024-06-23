class CreateUserTags < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_tags, %i[user_id tag_id], unique: true
  end
end
