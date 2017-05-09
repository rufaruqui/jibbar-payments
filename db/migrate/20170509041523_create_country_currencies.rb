class CreateCountryCurrencies < ActiveRecord::Migration[5.0]
  def change
    create_table :country_currencies do |t|
      t.string :country
      t.string :currency

      t.timestamps
    end
  end
end
