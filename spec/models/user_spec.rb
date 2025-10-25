require 'rails_helper'

RSpec.describe User, type: :model do
  describe "happy paths" do
    before(:each) do
       @user =  @user1 = User.create!(username: "user1", email: "user1@gmail.com")

       @character = Character.create!(name: "Lynn Thorn",
                                      level: 3,
                                      experience_points: 320,
                                      alignment: "Neutral Neutral",
                                      background: "Artisan",
                                      user_id: @user.id,
                                      character_class_id: "rogue",
                                      race_id: "half-elf",
                                      subclass_id: "",
                                      subrace_id: "")

    end

    describe "associations" do
      it { should have_many(:characters).dependent(:destroy) }

      it "destroys associated characters when user is destroyed" do
        expect(@user.characters.count).to eq(1)
        expect(@user.characters.pluck(:id)).to include(@character.id)

        expect { @user.destroy }.to change { Character.count }.by(-1)

        expect(Character.exists?(@character.id)).to be false
      end
    end

    describe "validations" do
      it { should validate_presence_of(:username) }
      it { should validate_presence_of(:email) }
    end
  end
end
