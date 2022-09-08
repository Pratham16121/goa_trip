class AddColEmailToEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :email, :string
  end
end
