class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :rank
      t.integer :suit
      t.timestamps null: false
    end
  end
end
