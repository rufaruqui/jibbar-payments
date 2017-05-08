class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :template_id
      t.string :user
      t.string :subject
      t.text :body
      t.integer :state, default: 0
      t.string :public_id
      t.string :from_name
      t.string :from_address
      t.string :reply_address
      t.datetime :scheduled_on
      t.datetime :sent_on
      t.jsonb :recipients, null: false, default: []
      t.timestamps
    end
    add_index :emails, :public_id, unique: true
  end
end
