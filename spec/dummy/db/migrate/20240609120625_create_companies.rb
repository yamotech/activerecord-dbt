class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :establishment_date
      t.float :average_age
      t.boolean :published, null: false, default: false

      t.timestamps
    end
  end
end
