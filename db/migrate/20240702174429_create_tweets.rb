class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.string :message
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end

