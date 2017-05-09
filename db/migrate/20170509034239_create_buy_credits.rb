class CreateBuyCredits < ActiveRecord::Migration[5.0]
  def change
    create_table :buy_credits do |t|
      t.string :code, :null=>false, :unique=>true
      t.string :name, :null=>false
      t.string :description
      t.integer :credits, :default=>0, :null=>false
      t.integer :broadcasts
      t.integer :duration_in_days
      t.boolean :display, :default=>1
      t.decimal :price, precision: 10, scale: 2, :default=>0.00
      t.integer :minimum_members
      t.integer :maximum_members
      t.boolean :is_plan_for_team, :default=>0
   
      t.timestamps
    end
  end
end
