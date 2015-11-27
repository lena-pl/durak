class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :kind
      t.references :game, index: true
      t.references :player, index: true
      t.references :active_card, index: true
      t.references :passive_card, index: true
      t.timestamps null: false
    end
  end
end
