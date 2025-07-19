require "rails_helper"

RSpec.describe "users endpoints", type: :request do
  it "should retrieve all users" do
    bob = User.create(username: "Bob3", email: "bob3@gmail.com")
    

  end

  xit "should create a new user" do

  end

  xit "should retrieve one user" do

  end
end