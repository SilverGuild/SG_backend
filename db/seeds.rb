# Remove following section upon reaching production
Rails.logger.info "Clearing database..."
User.destroy_all
Character.destroy_all

# Sample Character_Classes, Races (embedded Subclasses, Subraces, and languages), Alignments, and Backgrounds
CHARACTER_CLASSES = {
  'barbarian' => { subclasses: [ 'berserker', nil ] },
  'bard' => { subclasses: [ 'lore', nil ] },
  'cleric' => { subclasses: [ 'life', nil ] },
  'druid' => { subclasses: [ 'land', nil ] },
  'fighter' => { subclasses: [ 'champion', nil ] },
  'monk' => { subclasses: [ 'open-hand', nil ] },
  'paladin' => { subclasses: [ 'devotion', nil ] },
  'ranger' => { subclasses: [ 'hunter', nil ] },
  'rogue' => { subclasses: [ 'thief', nil ] },
  'sorcerer' => { subclasses: [ 'draconic', nil ] },
  'warlock' => { subclasses: [ 'fiend', nil ] },
  'wizard' => { subclasses: [ 'evocation', nil ] }
}
RACES = {
  'dragonborn' => { subraces: [ nil ], languages: [ 'common', 'draconic' ] },
  'dwarf' => { subraces: [ 'hill-dwarf', nil ], languages: [ 'common', 'dwarfish' ] },
  'elf' => { subraces: [ 'high-elf', nil ], languages: [ 'common', 'elvish' ] },
  'gnome' => { subraces: [ 'rock-gnome', nil ], languages: [ 'common', 'gnomish' ] },
  'half-elf' => { subraces: [ nil ], languages: [ 'common', 'elvish' ] },
  'half-orc' => { subraces: [ nil ], languages: [ 'common', 'orc' ] },
  'halfling' => { subraces: [ 'lightfoot-halfling', nil ], languages: [ 'common', 'halfling' ] },
  'human' => { subraces: [ nil ], languages: [ 'common' ] },
  'tiefling' => { subraces: [ nil ], languages: [ 'common', 'infernal' ] }
}

ALIGNMENTS = %w[
  lawful-good neutral-good chaotic-good lawful-neutral true-neutral chaotic-neutral lawful-evil neutral-evil chaotic-evil
].freeze

BACKGROUNDS = %w[
  acolyte charlatan criminal entertainer folk hero guild artisan hermit noble outlander sage sailor soldier urchin
].freeze

ABILITIES = %w[ str dex con int wis cha ].freeze

SKILLS = %w[
  acrobatics animal-handling arcana athletics deception history
  insight intimidation investigation medicine nature perception
  performance persuasion religion sleight-of-hand stealth survival
].freeze

def assign_ability_scores(character)
  saving_throw_ids = ABILITIES.sample(2)

  ABILITIES.each do |ability_id|
    character.ability_scores.create!(
      ability_id: ability_id,
      score: rand(8..18),
      saving_throw_proficient: saving_throw_ids.include?(ability_id)
    )
  end
end

def assign_skills(character)
  proficient_skill_ids = SKILLS.sample(rand(2..4))
  expertise_skill_ids = rand < 0.3 ? proficient_skill_ids.sample(1) : []

  SKILLS.each do |skill_id|
    character.skills.create!(
      skill_id: skill_id,
      proficient: proficient_skill_ids.include?(skill_id),
      expertise: expertise_skill_ids.include?(skill_id)
    )
  end
end

# Create test users with Faker
Rails.logger.info "Creating test users with Faker..."
10.times do
  User.create!(
    username: Faker::Internet.unique.username(specifier: 5..12),
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password
  )
end

# Create test characters using Faker
Rails.logger.info "Creating test characters using Faker..."
User.all.each do |user|
  rand(3..8).times do
    # Handle random class associated subclass assignment
    character_class = CHARACTER_CLASSES.keys.sample
    subclass = CHARACTER_CLASSES[character_class][:subclasses].sample

    # Handle random race associated subrace assignment
    race = RACES.keys.sample
    subrace = RACES[race][:subraces].sample

    # Ensure that experience points are generated randomly based on the level
    level = rand(1..10)
    xp_thresholds = [ 0, 300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, 85000 ]
    experience_points = xp_thresholds[level - 1] + rand(0..(xp_thresholds[level] - xp_thresholds[level - 1]))

    character = user.characters.create!(
      name: Faker::Games::ElderScrolls.name,
      level: level,
      experience_points: experience_points,
      alignment: ALIGNMENTS.sample,
      background: BACKGROUNDS.sample,
      character_class_id: character_class,
      race_id: race,
      subclass_id: subclass,
      subrace_id: subrace,
      languages: RACES[race][:languages]
    )

    assign_ability_scores(character)
    assign_skills(character)
  end
end

Rails.logger.info "Creating admin account for development"
admin = User.create!(
  username: "sg_admin",
  email: "sg_admin@gmail.com",
  password: "dnd4life"
)

Rails.logger.info "Create test characters for admin account"
8.times do
  # Handle random class associated subclass assignment
  character_class = CHARACTER_CLASSES.keys.sample
  subclass = CHARACTER_CLASSES[character_class][:subclasses].sample

  # Handle random race associated subrace assignment
  race = RACES.keys.sample
  subrace = RACES[race][:subraces].sample

  # Ensure that experience points are generated randomly based on the level
  level = rand(1..10)
  xp_thresholds = [ 0, 300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, 85000 ]
  experience_points = xp_thresholds[level - 1] + rand(0..(xp_thresholds[level] - xp_thresholds[level - 1]))

  character = admin.characters.create!(
    name: Faker::Games::ElderScrolls.name,
    level: level,
    experience_points: experience_points,
    alignment: ALIGNMENTS.sample,
    background: BACKGROUNDS.sample,
    character_class_id: character_class,
    race_id: race,
    subclass_id: subclass,
    subrace_id: subrace,
    languages: RACES[race][:languages]
  )

  assign_ability_scores(character)
  assign_skills(character)
end
