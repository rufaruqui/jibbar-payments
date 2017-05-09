class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :public_id, :null=>false
      t.string :customer
      t.datetime :active_until
      t.boolean :recurrent, :default=>false, :null=>false
      t.string :plan
      t.string :status, :default=>"pending"
      t.string :stripe_charge
      t.string :stripe_invoice
      t.string :stripe_subscription

      t.timestamps
    end
  end
end
