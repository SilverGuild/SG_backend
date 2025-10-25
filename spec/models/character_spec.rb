require 'rails_helper'

RSpec.describe Character, type: :model do
  describe "happy paths" do
    before(:each) do
      @user =  @user1 = User.create!(username: "user1", email: "user1@gmail.com")

      @character = Character.create!(name: "Kaelynn Thornwick",
                                      level: 1,
                                      experience_points: 0,
                                      alignment: "Neutral Good",
                                      background: "Hermit",
                                      user_id: @user.id,
                                      character_class_name: "druid",
                                      race_name: "gnome")
    end

    describe "relationships" do
      it { should belong_to(:user) }
    end

    describe "validations" do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:level) }
      it { should validate_presence_of(:experience_points) }
      it { should validate_presence_of(:alignment) }
      it { should validate_presence_of(:background) }
      it { should validate_presence_of(:user_id) }
      it { should validate_presence_of(:character_class_name) }
      it { should validate_presence_of(:race_name) }
    end

    describe "helper methods" do
      it "fetches character class details and returns a PORO" do
        VCR.use_cassette("model_character_class_details_druid") do
          test_class = @character.character_class

          expect(test_class).to be_an_instance_of CharacterClassPoro
          expect(test_class.id).to eq("druid")
          expect(test_class.name).to eq("Druid")
          expect(test_class.url).to eq("/api/2014/classes/druid")
          expect(test_class.hit_die).to eq(8)
          expect(test_class.skill_proficiencies[:choose]).to eq(2)
          expect(test_class.skill_proficiencies[:skills]).to eq([ "arcana", "animal-handling", "insight", "medicine", "nature", "perception", "religion", "survival" ])
          expect(test_class.saving_throw_proficiencies).to eq([ "int", "wis" ])
        end
      end

      it "fetches character race details and returns a PORO" do
        VCR.use_cassette("model_character_race_details_gnome") do
          test_race = @character.race

          expect(test_race).to be_an_instance_of RacePoro
          expect(test_race.id).to eq("gnome")
          expect(test_race.name).to eq("Gnome")
          expect(test_race.speed).to eq(25)
          expect(test_race.size).to eq("Small")
          expect(test_race.ability_bonuses.first[:ability_score][:index]).to eq("int")
          expect(test_race.ability_bonuses.first[:bonus]).to eq(2)
          expect(test_race.age_description).to eq("Gnomes mature at the same rate humans do, and most are expected to settle down into an adult life by around age 40. They can live 350 to almost 500 years.")
          expect(test_race.alignment_description).to eq("Gnomes are most often good. Those who tend toward law are sages, engineers, researchers, scholars, investigators, or inventors. Those who tend toward chaos are minstrels, tricksters, wanderers, or fanciful jewelers. Gnomes are good-hearted, and even the tricksters among them are more playful than vicious.")
          expect(test_race.size_description).to eq("Gnomes are between 3 and 4 feet tall and average about 40 pounds. Your size is Small.")
          expect(test_race.language_description).to eq("You can speak, read, and write Common and Gnomish. The Gnomish language, which uses the Dwarvish script, is renowned for its technical treatises and its catalogs of knowledge about the natural world.")
          expect(test_race.languages.first[:index]).to eq("common")
        end
      end
    end
  end
end
