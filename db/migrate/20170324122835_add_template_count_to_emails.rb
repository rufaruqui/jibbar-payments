class AddTemplateCountToEmails < ActiveRecord::Migration[5.0]
  def self.up
    add_column :emails, :template_count, :integer, :default =>0
    Email.reset_column_information
    Email.all.each do |e|
    	e.refresh_template_count
    end
  end
  def self.down
    remove_column :emails, :template_count
  end
end
