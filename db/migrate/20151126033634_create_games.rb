class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :trump_card, index: true
      t.timestamps null: false
    end
  end
end
