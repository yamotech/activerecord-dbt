class CreateHoges < ActiveRecord::Migration[7.2]
  def change
    create_table :hoges do |t|
      t.string :title

      t.timestamps
    end
  end
end
