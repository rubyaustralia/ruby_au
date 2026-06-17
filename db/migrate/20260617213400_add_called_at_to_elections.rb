class AddCalledAtToElections < ActiveRecord::Migration[8.0]
  def change
    add_column :elections, :called_at, :datetime
  end
end
