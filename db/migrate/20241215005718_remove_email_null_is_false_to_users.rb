class RemoveEmailNullIsFalseToUsers < ActiveRecord::Migration[7.2]
  def up
    # temporary hack, we will remove email column after multiple emails change is applied to producation
    change_column_null :users, :email, true
  end
end
