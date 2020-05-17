class CreateInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :interviews do |t|
      t.string :title
      t.text :participants_email
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
