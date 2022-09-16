class RoomsController < ApplicationController

  def fetch_room_details
    rooms = Room.select("room_number", "full_name", "room_mate1", "room_mate2", "room_mate3", "id","created_at").as_json
    if(rooms.present?)
      rooms.each_with_index do |room, i|
        time=rooms[i]["created_at"]
        time[10]=" "
        rooms[i]["created_at"] = time[0,19]
        room_mates_name = Employee.select("full_name", "emp_id").where(emp_id: [room["room_mate1"], room["room_mate2"], room["room_mate3"]]).as_json
        list_name = Hash.new
        list_name[room_mates_name[0]["emp_id"]] = room_mates_name[0]["full_name"]
        list_name[room_mates_name[1]["emp_id"]] = room_mates_name[1]["full_name"]
        list_name[room_mates_name[2]["emp_id"]] = room_mates_name[2]["full_name"]
        rooms[i]["names"] = list_name
      end
      render status: 200, json: {"room_details": rooms}
    else
      render status: 400, json: {result: "No Rooms booked"}
    end
  end

  def delete_room
    if (params[:room_number].present?)
      room_id = params[:room_number]
      room = Room.find_by_room_number(room_id)
      if(room)
        emp_ids = [room.room_mate1,room.room_mate2,room.room_mate3]
        Employee.where(emp_id: emp_ids).update_all(allocated: false, room: nil)      
        room.destroy
        render status: 200, json: {result: "Room deleted Successfully"}
      else
        render status: 400, json: {error: "Room not found"}
      end
    else
      render status: 422, json: {error: "Unproccessable entity"}
    end
  end

  private

  def room_parameters
    params.require(:room_number).permit()
  end

end
