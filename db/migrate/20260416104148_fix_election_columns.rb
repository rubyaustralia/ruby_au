class FixElectionColumns < ActiveRecord::Migration[8.1]
  def change
    change_table :elections do |t|
      t.integer :point_scale, default: 10, null: false
      t.remove :maximum_score, type: :integer, default: 5, null: false
      t.remove :minimum_score, type: :integer, default: -5, null: false
    end
  end
end
