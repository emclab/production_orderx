class CreateProductionOrderxProductionSteps < ActiveRecord::Migration
  def change
    create_table :production_orderx_production_steps do |t|
      t.integer :part_production_id
      t.integer :step_status_id
      t.integer :qty_in
      t.integer :qty_out
      t.text :brief_note
      t.integer :last_updated_by_id
      t.string :ontime_indicator

      t.timestamps
    end
    
    add_index :production_orderx_production_steps, :step_status_id
    add_index :production_orderx_production_steps, :part_production_id
    add_index :production_orderx_production_steps, :ontime_indicator
  end
end
