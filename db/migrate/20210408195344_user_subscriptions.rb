class UserSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
