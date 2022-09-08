require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RSpec.describe Employee, :type => :model do


  #meta data space - dummy 
  #execution cntxt

  subject { described_class.new(full_name: "test user", emp_id: "086", gender: "male") }


  it "is valid with valid attributes" do
    expect(subject).to be_valid
    do_request
  end

  it "is not valid without a full_name" do
    subject.full_name = nil
#    subject.save!
    expect(subject.reload).to_not be_valid
  end
end
