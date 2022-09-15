require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Employees' do
  explanation "Employees resource"
  header "Content-Type", "application/json"
  
  get '/employees' do
    context '200' do
      before do
        e = Employee.new(full_name: "Rutuja Nirmal", emp_id: 13, gender: 'F')
        e.save!
      end
      example_request 'Getting a list of employees' do
        expect(status).to eq(200)
      end
    end
  end

  get '/empdetails' do
    parameter :email, "Email ID"
    context '200' do
      before do
        e = Employee.new(full_name: "Rutuja Nirmal", emp_id: 13, gender: 'F',email: 'rutuja.nirmal@joshsoftware.com')
        e.save!
      end
      example_request 'Get employee details using email' do
        do_request :email => "rutuja.nirmal@joshsoftware.com"
        response_headers["Content-Type"].should eq("application/json; charset=utf-8")
        status.should eq(200)
        # str_data = Employee.select("full_name","emp_id","gender","allocated","room").where(emp_id: 13).to_json
        response_body.should eq('{"full_name":"Rutuja Nirmal","emp_id":"13","gender":"F","allocated":false,"room":null,"id":null}')
        # response_body.should eq(str_data)

      end
    end 
    
    context '400' do
      before do
        e = Employee.new(full_name: "Rutuja Nirmal", emp_id: 13, gender: 'F',email: 'rutuja.nirmal@joshsoftware.com')
        e.save!
      end
      example_request 'Empty/Different domain email' do
        do_request :email => ""
        response_headers["Content-Type"].should eq("application/json; charset=utf-8")
        status.should eq(400)
        response_body.should eq('{"error":"Use Joshsoftware email"}')
      end
    end 

    context '400' do
      before do
        e = Employee.new(full_name: "Rutuja Nirmal", emp_id: 13, gender: 'F',email: 'rutuja.nirmal@joshsoftware.com')
        e.save!
      end
      example_request 'Email not found' do
        do_request :email => "rutuja.nirmal@joshsoftware.digital"
        response_headers["Content-Type"].should eq("application/json; charset=utf-8")
        status.should eq(400)
        response_body.should eq('{"error":"Email Not Found"}')
      end
    end 
  end

  put "/booking" do
    parameter :id1, "user 1", required: true
    parameter :id2, "user 2", required: true
    parameter :id3, "user 3", required: true
    before do
      Employee.create(emp_id: "J001",full_name:"Rutuja",gender: "f")
      Employee.create(emp_id: "J002",full_name:"Sreenidhi",gender: "f")
      Employee.create(emp_id: "J003",full_name:"Nandini",gender:"f")
    end
    context "200" do
      example_request 'Booking Successful' do
        puts "*******************************************************************"
        request = {
          ids:{id1: "J001",id2: "J002",id3: "J003"}
        }.to_json
        # puts temp

        do_request(request,)
        response_headers["Content-Type"].should eq("application/json; charset=utf-8")
        status.should eq(200)
        response_body.should eq('{"result":"Successful"}')
      end
    end
  end

end
