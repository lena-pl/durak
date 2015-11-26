class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :type
      t.references :game, index: true
      t.references :player, index: true
      t.references :card, index: true
      t.timestamps null: false
    end
  end
end
