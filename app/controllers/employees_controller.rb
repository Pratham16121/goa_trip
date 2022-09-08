class EmployeesController < ApplicationController
  def index
    # Get all employees data of emps whoms rooms are not alocated
    users = Employee.select("full_name", "emp_id", "gender").where("allocated": false)
    render json: users
  end

  def update
    # We will get the 3 emp_ids (r1,r2,r3). Update in the Employee Table
    ids = sortParams.as_json
    if ids.length != 3
      render status: 400 , json: {error: "Fail due to number of arguments"}
    else
      employees_data = Employee.select("full_name", "gender", "emp_id", "allocated").where("emp_id": [ids["id1"], ids["id2"], ids["id3"]]).as_json
      if room_mates_of_diffrent_gender?(employees_data)
        render status: 400, json: {error: "All three are not of same gender"}
      elsif any_one_allocated?(employees_data)
        render status: 400, json: {error: "any one of them is allocated"}
      else
        ids.each_value do |id|
          obj = Employee.find_by(emp_id: id)
          obj.allocated = true
          obj.save!
        end
        obj = Room.new
        obj.room_mate1, obj.room_mate2, obj.room_mate3 = ids["id1"], ids["id2"], ids["id3"]
        obj.full_name = Employee.find_by(emp_id: ids["id1"]).as_json["full_name"]
        obj.room_number = "A" + obj.room_mate1
        obj.save!
        render status: 200 , json: {result: "Successfull"}
      end
    end
  end

  def fetch_details
    # fetch the employee details from the email id provided
    email_id = params[:email].present? ? params[:email] : ""
    if(email_id.match(EMAIL_REGEX))
      user = Employee.select("full_name", "emp_id", "gender").where(email: email_id ).first
      if(user.present?)
        render status: 200 , json: user.as_json
      else
        render status: 400 , json: {error: "Email Not Found"}
      end
    else
      render status: 400 , json: {error: "Use Joshsoftware email"}
    end
  end

  private

  def any_one_allocated?(data)
    return data[0]["allocated"] || data[1]["allocated"] || data[2]["allocated"]
  end

  def room_mates_of_diffrent_gender?(data)
    if data[0]["gender"] == data[1]["gender"] && data[0]["gender"] == data[2]["gender"]
      return false
    end
    true
  end

  def sortParams
    params.require(:ids).permit(:id1, :id2, :id3)
  end
end
