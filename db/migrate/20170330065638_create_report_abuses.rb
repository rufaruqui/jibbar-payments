class CreateReportAbuses < ActiveRecord::Migration[5.0]
  def change
    create_table :report_abuses do |t|
      t.string :email_id
      t.string :recipient_id
      t.string :reason
      t.timestamps
    end
  end
end
