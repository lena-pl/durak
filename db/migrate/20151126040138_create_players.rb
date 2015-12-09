class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :game, index: true, null: false
      t.timestamps null: false
    end
  end
end
