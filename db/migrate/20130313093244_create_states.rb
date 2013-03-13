class CreateStates < ActiveRecord::Migration
  def up
    create_table :states do |t|
      t.string :abbr
      t.string :name
      t.float  :lat
      t.float  :lng
    end
    say 'Seeding United States'
    YAML::load_file(File.join(Rails.root, 'db', 'states.yml')).each do |state|
      say state['name'], true if State.create(state)
    end
  end

  def down
    drop_table :states
  end
end
