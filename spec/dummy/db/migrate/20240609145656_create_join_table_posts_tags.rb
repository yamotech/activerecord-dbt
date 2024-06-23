class CreateJoinTablePostsTags < ActiveRecord::Migration[7.1]
  def change
    create_join_table :posts, :tags, column_options: { foreign_key: true } do |t|
      t.index %i[post_id tag_id], unique: true
      t.index %i[tag_id post_id]
    end
  end
end
