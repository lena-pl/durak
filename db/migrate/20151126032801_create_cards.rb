class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :rank, null: false
      t.integer :suit, null: false
      t.timestamps null: false
    end
  end
end
