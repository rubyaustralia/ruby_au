class UpdateaAchievedAtToArchivedAt < ActiveRecord::Migration[8.0]
  def change
    rename_column :posts, :archieved_at, :archived_at
  end
end
