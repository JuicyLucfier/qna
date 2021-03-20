class CreateBadges < ActiveRecord::Migration[6.1]
  def change
    create_table :badges do |t|
      t.string :title, null: false
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
