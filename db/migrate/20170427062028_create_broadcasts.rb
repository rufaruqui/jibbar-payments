class CreateBroadcasts < ActiveRecord::Migration[5.0]
  def change
    create_table :broadcasts do |t|
      t.string :email_id
      t.string :emails_subject
      t.string :meta_data
      t.integer :number_of_recipient
      t.integer :total_credit_consumed
      t.string :user_id

      t.timestamps
    end
    add_index :broadcasts, [ :user_id, :email_id ], :unique => true
  end
end
