class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :kind, null: false
      t.references :player, index: true, null: false
      t.references :card, index: true
      t.references :in_response_to_step
      t.index :in_response_to_step_id, unique: true
      t.timestamps null: false
    end
  end
end
