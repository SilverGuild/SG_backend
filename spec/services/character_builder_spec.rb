require "rails_helper"

RSpec.describe CharacterBuilder do
  let(:password) { "password123" }
  let(:user) { User.create!(username: "builder_user", email: "builder_user@gmail.com", password: password) }

  let(:character_params) do
    {
      name: "Builder Test Character",
      level: 1,
      experience_points: 0,
      alignment: "Neutral Good",
      background: "Hermit",
      character_class_id: "wizard",
      race_id: "human",
      languages: [ "common" ]
    }
  end

  let(:ability_scores_params) do
    [
      { ability_id: "str", score: 10, saving_throw_proficient: false },
      { ability_id: "dex", score: 14, saving_throw_proficient: true },
      { ability_id: "con", score: 12, saving_throw_proficient: false },
      { ability_id: "int", score: 16, saving_throw_proficient: true },
      { ability_id: "wis", score: 11, saving_throw_proficient: false },
      { ability_id: "cha", score: 8, saving_throw_proficient: false }
    ]
  end

  let(:skills_params) { [ { skill_id: "arcana", proficient: true, expertise: false } ] }

  let(:combat_stats_params) do
    {
      current_hp: 8, max_hp: 8, temporary_hp: 0, hit_dice_remaining: 1,
      death_save_successes: 0, death_save_failures: 0, stable: true,
      armor_class: 12, conditions: []
    }
  end

  subject(:result) do
    described_class.new(
      user: user,
      character_params: character_params,
      ability_scores_params: ability_scores_params,
      skills_params: skills_params,
      combat_stats_params: combat_stats_params
    ).call
  end

  describe "#call" do
    context "happy path" do
      context "full payload" do
        it "returns a successful result" do
          expect(result.success?).to be true
        end

        it "persists the character" do
          expect { result }.to change(Character, :count).by(1)
        end

        it "builds all 6 ability score rows" do
          expect(result.character.ability_scores.count).to eq(6)
        end

        it "builds the skill rows" do
          expect(result.character.skills.count).to eq(1)
        end

        it "builds combat_stats" do
          expect(result.character.combat_stats).to be_present
          expect(result.character.combat_stats.current_hp).to eq(8)
        end
      end

      context "skills omitted (sparse/optional per skill design)" do
        let(:skills_params) { [] }

        it "still succeeds" do
          expect(result.success?).to be true
          expect(result.character.skills.count).to eq(0)
        end
      end

      context "combat_stats omitted" do
        let(:combat_stats_params) { {} }

        it "succeeds without building combat_stats" do
          expect(result.success?).to be true
          expect(result.character.combat_stats).to be_nil
        end
      end
    end

    context "sad path" do
      context "duplicate ability_id values" do
        let(:ability_scores_params) do
          [
            { ability_id: "str", score: 10, saving_throw_proficient: false },
            { ability_id: "str", score: 12, saving_throw_proficient: true }
          ]
        end

        it "fails without touching the database" do
          expect { result }.not_to change(Character, :count)
        end

        it "adds a duplicate error on :ability_scores" do
          expect(result.character.errors[:ability_scores]).to include("contains duplicate ability_id values")
        end
      end

      context "duplicate skill_id values" do
        let(:skills_params) do
          [
            { skill_id: "arcana", proficient: true, expertise: false },
            { skill_id: "arcana", proficient: false, expertise: false }
          ]
        end

        it "fails without touching the database" do
          expect { result }.not_to change(Character, :count)
        end

        it "add a duplicate error on :skills" do
          expect(result.character.errors[:skills]).to include("contains duplicate skill_id values")
        end
      end

      context "rollback on partial failure" do
        let(:ability_scores_params) do
          [
            { ability_id: "str", score: 10, saving_throw_proficient: false },
            { ability_id: "dex", score: 999, saving_throw_proficient: false } # exceeds the 1-30 range
          ]
        end

        it "does not persist the character" do
          expect { result }.not_to change(Character, :count)
        end

        it "does not persist any ability score rows" do
          result
          expect(CharacterAbilityScore.count).to eq(0)
        end

        it "returns a failed result" do
          expect(result.success?).to be false
        end
      end

      context "character with nil level, combat_stats.hit_dice_reamining present" do
        let(:character_params) do
          {
            name: "No Level Character",
            experience_points: 0,
            alignment: "Neutral Good",
            background: "Hermit",
            character_class_id: "wizard",
            race_id: "human",
            languages: [ "common" ]
          }
        end

        it "fails validation cleanly instead of raising" do
          expect { result }.not_to raise_error
          expect(result.success?).to be false
        end
      end
    end
  end
end
