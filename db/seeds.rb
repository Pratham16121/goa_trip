# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'csv'

CSV.foreach(Rails.root.join('lib/seeds/test.csv'), headers: true) do |row|
  t = Employee.new
  t.full_name = row['Name']
  t.emp_id = row['Emp_Id']
  t.gender = row['Gender']
  t.email = row['Email']
  t.save!

  puts "#{t.full_name} - #{t.emp_id} Saved!"
end

puts "There are #{Employee.count} in the employees table"
