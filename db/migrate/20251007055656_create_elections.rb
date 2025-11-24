class CreateElections < ActiveRecord::Migration[8.0]
  def change
    create_table :elections do |t|
      t.string :title, null: false
      t.integer :vacancies, default: 1, null: false
      t.integer :point_scale, default: 10, null: false
      t.datetime :opened_at
      t.datetime :closed_at

      t.timestamps
    end
  end
end
