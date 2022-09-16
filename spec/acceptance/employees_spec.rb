require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Employees' do
  explanation "Employees resource"
   
  get '/employees' do
    context '200' do
      before do
        e = Employee.new(full_name: "Rutuja Nirmal", emp_id: 13, gender: 'F')
        e.save!
      end
      it 'GET : Get list of employees whom room is not allocated(User)' do
        do_request()
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
      it 'GET : Get employee details using email' do
        do_request :email => "rutuja.nirmal@joshsoftware.com"
        status.should eq(200)
        response_body.should eq('{"full_name":"Rutuja Nirmal","emp_id":"13","gender":"F","allocated":false,"room":null,"id":null}')
      end
    end 
    
    context '400' do
      before do
        e = Employee.new(full_name: "Rutuja Nirmal", emp_id: 13, gender: 'F',email: 'rutuja.nirmal@joshsoftware.com')
        e.save!
      end
      it 'GET : FAIL Get employee due to Empty/Different domain email' do
        do_request :email => ""
        response_body.should eq('{"error":"Use Joshsoftware email"}')
      end
    end 

    context '400' do
      before do
        e = Employee.new(full_name: "Rutuja Nirmal", emp_id: 13, gender: 'F',email: 'rutuja.nirmal@joshsoftware.com')
        e.save!
      end
      it 'GET : Fail Get employee due to Email Not Found' do
        do_request :email => "rutuja.nirmal@joshsoftware.digital"
        status.should eq(400)
        response_body.should eq('{"error":"Email Not Found"}')
      end
    end 
  end

  post 'employees/new' do

    context '200' do
      it 'POST : New Employee-Employee created successfully' do
        employee_parameters = {
          employee_details: {
            full_name: "Nandini Jhanwar",
            emp_id: 89,
            gender: "F",
            email: "nandini.jhanwar@joshsoftware.com"
          }
        }
        do_request(employee_parameters)
        status.should eq(200)
        response_body.should eq('{"result":"Employee created Successfully"}')
      end
    end

    context '400' do
      before do
        Employee.create(full_name: "Nandini Jhanwar", emp_id: 89, gender: 'F',email: 'nandini.jhanwar@joshsoftware.com')
      end
      it 'POST : New Employee-Employee already exits' do
        employee_parameters = {
          employee_details: {
            full_name: "Nandini Jhanwar",
            emp_id: 89,
            gender: "F",
            email: "nandini.jhanwar@joshsoftware.com"
          }
        }
        do_request(employee_parameters)
        status.should eq(400)
        response_body.should eq('{"error":"Employee Already exits"}')
      end
    end

    context '400' do
      it 'POST : New Employee-Use Josh software email' do
        employee_parameters = {
          employee_details: {
            full_name: "Nandini Jhanwar",
            emp_id: 89,
            gender: "F",
            email: "nandini.jhanwar67@joshsoftware.com"
          }
        }
        do_request(employee_parameters)
        status.should eq(400)
        response_body.should eq('{"error":"Provide joshsoftware emailId"}')
      end
    end

    context '400' do
      it 'POST : New Employee-Gender Details : other than (M/F)' do
        employee_parameters = {
          employee_details: {
            full_name: "Nandini Jhanwar",
            emp_id: 89,
            gender: "Female",
            email: "nandini.jhanwar@joshsoftware.com"
          }
        }
        do_request(employee_parameters)
        status.should eq(400)
        response_body.should eq('{"error":"Provide gender M or F"}')
      end
    end

    context '400' do
      it 'POST : New Employees-Wrong parameters passed (blank emp_id/only firstname)' do
        employee_parameters = {
          employee_details: {
            full_name: "Nandini",
            emp_id: "",
            gender: "F",
            email: "nandini.jhanwar67@joshsoftware.com"
          }
        }
        do_request(employee_parameters)
        status.should eq(400)
        response_body.should eq('{"error":"Wrong parameters passed"}')
      end
    end
  end

  get '/employees/pending' do
    before do
      Employee.destroy_all
      emp1 = Employee.create(
        full_name: "Nandini Jhanwar",
        emp_id: 89,
        gender: 'F',
        email: "nandini.jhanwar@josh.software",
        allocated: false
      )
      emp2 = Employee.create(
        full_name: "Rutuja Nirmal",
        emp_id: 77,
        gender: 'F',
        email: "nrutuja.nirmal@josh.software",
        allocated: false
      )
      emp3 = Employee.create(
        full_name: "Sreenidhi Bendre",
        emp_id: 78,
        gender: 'F',
        email: "sreenidhi.bendre@josh.software",
        allocated: true
      )
    end

    context '200' do
      it "GET : Bookings-Show all the employees who haven't been allocated with the rooms yet(Admin)" do
        do_request
        status.should eq(200)
      end
    end

    context '200' do
      before do
        Employee.destroy_all
        emp1 = Employee.create(
          full_name: "Nandini Jhanwar",
          emp_id: 89,
          gender: 'F',
          email: "nandini.jhanwar@josh.software",
          allocated: true
        )
        emp2 = Employee.create(
          full_name: "Rutuja Nirmal",
          emp_id: 77,
          gender: 'F',
          email: "nrutuja.nirmal@josh.software",
          allocated: true
        )
        emp3 = Employee.create(
          full_name: "Sreenidhi Bendre",
          emp_id: 78,
          gender: 'F',
          email: "sreenidhi.bendre@josh.software",
          allocated: true
        )
      end
      it 'GET : Bookings-All employees have booked their rooms' do
        do_request
        status.should eq(200)
        response_body.should eq('{"result":"All employees have booked their rooms"}')
      end
    end
  end

  put '/booking' do

    context '200' do
      before do
        emp1 = Employee.create(
          full_name: "Nandini Jhanwar",
          emp_id: 89,
          gender: 'F',
          email: "nandini.jhanwar@josh.software",
          allocated: false
        )
        emp2 = Employee.create(
          full_name: "Rutuja Nirmal",
          emp_id: 77,
          gender: 'F',
          email: "nrutuja.nirmal@josh.software",
          allocated: false
        )
        emp3 = Employee.create(
          full_name: "Sreenidhi Bendre",
          emp_id: 78,
          gender: 'F',
          email: "sreenidhi.bendre@josh.software",
          allocated: false
        )
      end
      it 'PUT : Successful booking for all the three employees' do
        id_params = {
          ids: {
            id1: 89,
            id2: 77,
            id3: 78
          }
        }
        do_request(id_params)
        status.should eq(200)
        response_body.should eq('{"result":"Successful"}')
      end
    end

    context '400' do
      it 'PUT : Check if there are exact 3 employees for room booking' do
        id_params = {
          ids: {
            id1: 23,
            id2: 34
          }
        }
        do_request(id_params)
        status.should eq(400)
        response_body.should eq('{"error":"Fail due to number of arguments"}')
      end
    end

    context '400' do
      before do
        # Employee.destroy_all
        @emp1 = Employee.create(
          full_name: "Nandini Jhanwar",
          emp_id: 89,
          gender: 'F',
          email: "nandini.jhanwar@josh.software",
          allocated: false
        )
        @emp2 = Employee.create(
          full_name: "Rutuja Nirmal",
          emp_id: 77,
          gender: 'F',
          email: "nrutuja.nirmal@josh.software",
          allocated: false
        )
        @emp3 = Employee.create(
          full_name: "Sreenidhi Bendre",
          emp_id: 78,
          gender: 'F',
          email: "sreenidhi.bendre@josh.software",
          allocated: true
        )
      end

      it 'PUT : When one of the employee is already allocated' do
        id_params = {
          ids: {
            id1: 89,
            id2: 77,
            id3: 78
          }
        }
        do_request(id_params)
        status.should eq(400)
        response_body.should eq("{\"error\":\" ALREADY ALLOCATED :  , #{@emp3.full_name}\"}")
      end
    end
  end
end