require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Rooms' do
  explanation "Rooms resource"
  header "Content-Type", "application/json"
  
  before do
    room = Room.new(room_number: "AJ001" , full_name:"Rutuja",room_mate1: "J001",room_mate2: "J002",room_mate3:"J003")
  end

  get "/rooms_details" do
    context '200' do
      example_request 'Getting a details of room-booking' do
        expect(status).to eq(200)
        response_body.should eq('{"room_number": "AJ001" , "full_name":"Rutuja","room_mate1": "J001","room_mate2": "J002","room_mate3":"J003"}')
      end
    end
  end

end