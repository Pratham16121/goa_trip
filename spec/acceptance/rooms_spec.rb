require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Rooms' do
  explanation "Rooms resource"
  header "Content-Type", "application/json"

  get "/room_details" do

    before do
      Room.destroy_all
      Employee.destroy_all
      Room.create(room_number: "AJ001" , full_name:"Rutuja",room_mate1: "J001",room_mate2: "J002",room_mate3:"J003")
      Employee.create(emp_id: "J001",full_name:"Rutuja",gender: "F")
      Employee.create(emp_id: "J002",full_name:"Sreenidhi",gender: "F")
      Employee.create(emp_id: "J003",full_name:"Nandini",gender:"F")
    end

    context '200' do
      example_request 'GET Room booking : Get details of all room-bookings' do
        expect(status).to eq(200)
        room = Room.select("room_number", "full_name", "room_mate1", "room_mate2", "room_mate3", "id","created_at").first
        
        expected_output={
          room_details:[{
            room_number: room.room_number,
            full_name: room.full_name,
            room_mate1: room.room_mate1,
            room_mate2: room.room_mate2,
            room_mate3: room.room_mate3,
            id: room.id,
            created_at: room.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            names: {J001:"Rutuja",J002:"Sreenidhi",J003:"Nandini"}}]
        }.to_json
        # response_body.should eq(expected_output)
      end
    end

    context '400' do
      before do
        Room.destroy_all
      end
      example_request 'GET Room Booking : No bookings avaiable' do
        expect(status).to eq(400)
        response_body.should eq('{"result":"No Rooms booked"}')
      end
    end
  end

  delete "/booking/delete/:room_number" do
    before do
      Room.create(room_number: "AJ001" , full_name:"Rutuja",room_mate1: "J001",room_mate2: "J002",room_mate3:"J003")
      Employee.create(emp_id: "J001",full_name:"Rutuja",gender: "f")
      Employee.create(emp_id: "J002",full_name:"Sreenidhi",gender: "f")
      Employee.create(emp_id: "J003",full_name:"Nandini",gender:"f")
    end

    context '200' do
      let(:room_number) {"AJ001"}
      example_request 'DELETE Room Booking : Room deleted successfully' do
        status.should eq(200)
      end
    end
  
    # context '400' do
    #   let(:room_number) {"00000"}
    #   example_request 'DELETE Room Bokking : Room not found' do
    #     room_parameters = {
    #         room_number: 'AJ001'
    #       }
    #     do_request(room_parameters)
    #     status.should eq(400)
    #     response_body.should eq('{"error":"Room not found"}')
    #   end
    # end
    # context '422' do
    #   example_request 'GET Room Booking : Unprocessable Entity' do
    #     expect(status).to eq(422)
    #     response_body.should eq('{"error":"Unproccessable entity"}')
    #   end
    # end
  end

end