class AddLinksToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :links, :jsonb
  end
end
