require 'rails_helper'

RSpec.describe User, type: :model do
  describe "happy paths" do
    before(:each) do
       @user =  @user1 = User.create!(username: "user1", email: "user1@gmail.com")

       @character = Character.create!(name: "Kaelynn Thornwick",
                                      level: 3,
                                      experience_points: 320,
                                      alignment: "Neutral Neutral",
                                      background: "Artisan",
                                      user_id: @user.id,
                                      character_class_name: "rogue",
                                      race_name: "half-elf")
    end

    describe "relationships" do
      it { should have_many(:characters) }
    end

    describe "validations" do
      it { should validate_presence_of(:username) }
      it { should validate_presence_of(:email) }
    end
  end
end
