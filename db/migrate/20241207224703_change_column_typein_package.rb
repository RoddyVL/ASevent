class ChangeColumnTypeinPackage < ActiveRecord::Migration[7.1]
  def change
    change_column :packages, :hour, :string
  end
end
