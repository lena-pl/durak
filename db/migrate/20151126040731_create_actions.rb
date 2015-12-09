class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :kind
      t.references :player, index: true
      t.references :card, index: true
      t.references :in_response_to_action
      t.index :in_response_to_action_id, unique: true
      t.timestamps null: false
    end
  end
end
