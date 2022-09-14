class EmployeesController < ApplicationController
  def index
    # Get all employees data of emps whoms rooms are not alocated
    users = Employee.select("full_name", "emp_id", "gender").where("allocated": false)
    render status: 200, json: users
  end

  def update
    # We will get the 3 emp_ids (r1,r2,r3). Update in the Employee Table
    ids = sortParams
    x = 0
    ids.each_value do |id|
      x += 1
    end
    employees_data = Employee.select("full_name", "gender", "emp_id", "allocated").where("emp_id": [ids["id1"], ids["id2"], ids["id3"]]).as_json
    if x != 3
      render status: 400 , json: {error: "Fail due to number of arguments"}
    elsif no_one_allocate?employees_data
      ids.each_value do |id|
        obj = Employee.find_by(emp_id: id)
        obj.allocated = true
        obj.room = "A" + ids[:id1]
        obj.save!
      end

      obj = Room.new
      obj.room_mate1, obj.room_mate2, obj.room_mate3 = ids[:id1], ids[:id2], ids[:id3]
      obj.full_name = Employee.find_by(emp_id: ids[:id1]).full_name
      obj.room_number = "A" + ids[:id1]
      obj.save!
      render status: 200 , json: {result: "Successful"}
    end
  end

  def fetch_details
    # fetch the employee details from the email id provided
    email_id = params[:email].present? ? params[:email] : ""
    if(email_id.match(EMAIL_REGEX))
      user = Employee.select("full_name", "emp_id", "gender","allocated","room").where(email: email_id ).first
      if(user.present?)
        if(user.allocated)
          roommates = Employee.select("full_name").where("room": user.room)
          render status: 400 , json: {error: "Room already booked", mates: roommates}
        else
          render status: 200 , json: user.as_json
        end
      else
        render status: 400 , json: {error: "Email Not Found"}
      end
    else
      render status: 400 , json: {error: "Use Joshsoftware email"}
    end
  end

  def pending
    users = Employee.select("full_name", "emp_id", "email").where("allocated": false)
    if users.present?
      render status: 200, json: users
    else
      render status: 200, json: {result: "All employees have booked their rooms"}
    end
  end

  def create
    emp_detials = employee_parameters
    if(Employee.find_by_emp_id(emp_detials[:emp_id]).present?)
      render status: 400, json: {error: "Employee Already exits"}
    else
      if(emp_detials[:full_name].present? and emp_detials[:emp_id].present?)
        if(emp_detials[:email].match(EMAIL_REGEX))
          if(emp_detials[:gender].match(GENDER_REGEX))
            Employee.create(emp_detials)
            render status: 200, json: {result: "Employee created Successfully"}
          else
            render status: 400, json: {error: "Provide gender M or F"}
          end
        else
          render status: 400, json: {error: "Provide joshsoftware emailId"}
        end
      else
        render status: 400, json: {error: "Wrong parameters passed"}
      end
    end
  end

  private

  def sortParams
    params.require(:ids).permit(:id1, :id2, :id3)
  end

  def employee_parameters
    params.require(:employee_details).permit(:full_name, :emp_id, :gender, :email)
  end
  
  def no_one_allocate?(data)
    if data[0]["allocated"] || data[1]["allocated"] || data[2]["allocated"]
      already_allocated=""
      if(data[0]["allocated"])
        already_allocated+=data[0]["full_name"].to_str
      end
      if(data[1]["allocated"])
        already_allocated+=" , "+data[1]["full_name"].to_str
      end
      if(data[2]["allocated"])
        already_allocated+=" , "+data[2]["full_name"].to_str
      else
      end
      render json: {error: " ALREADY ALLOCATED : "+already_allocated}
      return false
    else
      return true
    end
  end

end
