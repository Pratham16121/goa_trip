class AddRoomColToEmplyees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :room , :string
  end
end
