class EmployeesController < ApplicationController
  def index
    # Get all employees data of emps whoms rooms are not alocated
    @Users = Employee.select("full_name", "emp_id", "gender").where("allocated": false)
    render json: @Users
  end
  def update
    # We will get the 3 emp_ids (r1,r2,r3). Update in the Employee Table
    @ids = sortParams
    x = 0
    @ids.each_value do |id|
      x += 1
    end
    if x != 3
      render json: {"result": "Fail due to number of arguments"}
    else
      @ids.each_value do |id|
        obj = Employee.find_by(emp_id: id)
        obj.allocated = true
        obj.save!
      end
      obj = Room.new
      obj.room_mate1, obj.room_mate2, obj.room_mate3 = @ids[:id1], @ids[:id2], @ids[:id3]
      obj.full_name = Employee.find_by(emp_id: @ids[:id1]).full_name
      obj.room_number = "A" + obj.room_mate1
      obj.save!
      render json: {"result": "Successfull"}
    end
  end

  def fetch_details
    # fetch the employee details from the email id provided
    @User = Employee.select("full_name", "emp_id", "gender").where(email: params[:email] )

    # @User = Employee.find(params[:id])
    render json: @User
  end

  def fetch_room_details
    rooms = Room.select("room_number", "full_name", "room_mate1", "room_mate2", "room_mate3", "id").as_json
    # byebug
    list_name = Hash.new
    rooms.each_with_index do |room, i|
      # byebug
      room_mate1_name = Employee.select("full_name", "emp_id").where(emp_id: room["room_mate1"]).as_json[0]["full_name"]
      room_mate2_name = Employee.select("full_name", "emp_id").where(emp_id: room["room_mate2"]).as_json[0]["full_name"]
      room_mate3_name = Employee.select("full_name", "emp_id").where(emp_id: room["room_mate3"]).as_json[0]["full_name"] 
      list_name["1"] = room_mate1_name
      list_name["2"] = room_mate2_name
      list_name["3"] = room_mate3_name
      rooms[i]["names"] = list_name
    end
    # , "room_mate_names": {"1": room_mate1}
    render json: {"room_details": rooms}
  end

  private

  def sortParams
    params.require(:ids).permit(:id1, :id2, :id3)
  end
end
