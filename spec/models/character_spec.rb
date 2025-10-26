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
                                      character_class_id: "druid",
                                      subclass_id: "land",
                                      race_id: "gnome",
                                      subrace_id: "rock-gnome",
                                      languages: [ "common", "gnomish" ]
                                    )
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
      it { should validate_presence_of(:character_class_id) }
      it { should validate_presence_of(:race_id) }
      it { should validate_presence_of :languages }
    end

    describe "helper methods" do
      describe "data organization" do
        it "can add language ids from any source into characters langauges array" do
          learned_through_companion = [ "halfling", "elvish" ]
          divine_gift = "sylvan"

          expect(@character.languages.count).to eq(2)
          expect(@character.languages).to eq([ "common", "gnomish" ])
          
          @character.add_language(learned_through_companion, divine_gift)
          
          updated_languages = @character.languages

          expect(updated_languages.count).to eq(5)
          expect(updated_languages).to eq([ "common", "elvish", "gnomish", "halfling", "sylvan" ])
        end
      end

      describe "details retrieval" do
        it "CHARACTER_CLASS: fetches character class details and returns a PORO" do
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

        it "SUBCLASS: fetches subclass details and returns a PORO" do
          VCR.use_cassette("model_subclass_details_land") do
            test_subclass = @character.subclass

            expect(test_subclass).to be_an_instance_of SubclassPoro
            expect(test_subclass.id).to eq("land")
            expect(test_subclass.name).to eq("Land")
            expect(test_subclass.flavor).to eq("Druid Circle")
            expect(test_subclass.class_id).to eq("druid")
            expect(test_subclass.description).to eq("The Circle of the Land is made up of mystics and sages who safeguard ancient knowledge and rites through a vast oral tradition. These druids meet within sacred circles of trees or standing stones to whisper primal secrets in Druidic. The circle's wisest members preside as the chief priests of communities that hold to the Old Faith and serve as advisors to the rulers of those folk. As a member of this circle, your magic is influenced by the land where you were initiated into the circle's mysterious rites.")
            expect(test_subclass.url).to eq("/api/2014/subclasses/land")
          end
        end

        it "RACE: fetches character race details and returns a PORO" do
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
            expect(test_race.url).to eq("/api/2014/races/gnome")
          end
        end

        it "SUBRACE: fetches character subrace details and returns a PORO" do
          VCR.use_cassette("model_subrace_details_rock_gnome") do
            test_subrace = @character.subrace

            expect(test_subrace).to be_an_instance_of SubracePoro
            expect(test_subrace.id).to eq("rock-gnome")
            expect(test_subrace.name).to eq("Rock Gnome")
            expect(test_subrace.race_id).to eq("gnome")
            expect(test_subrace.description).to eq("As a rock gnome, you have a natural inventiveness and hardiness beyond that of other gnomes.")
            expect(test_subrace.ability_bonuses.first[:ability_score][:name]).to eq("CON")
            expect(test_subrace.ability_bonuses.first[:bonus]).to eq(1)
            expect(test_subrace.url).to eq("/api/2014/subraces/rock-gnome")
          end
        end

        it "LANGUAGE: fetches character language details and returns a PORO" do
          VCR.use_casssette("model_language_details_goblin") do
            language = @character.languages.last
            test_language = @character.language(language)

            expect(test_language[:type]).to eq("language")
            expect(test_language[:id]).to eq("gnomish")
            expect(test_language[:attributes][:name]).to eq("Gnomish")
            expect(test_language[:attributes][:language_type]).to eq("Standard")
            expect(test_language[:attributes][:typical_speakers]).to eq([ "Gnomes" ])
            expect(test_language[:attributes][:script]).to eq("Dwarvish")
          end
        end
      end
    end
  end
end
