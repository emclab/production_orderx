class CreateProductionOrderxPartProductions < ActiveRecord::Migration
  def change
    create_table :production_orderx_part_productions do |t|
      t.string :part_name
      t.string :part_num
      t.string :drawing_num
      t.text :requirement
      t.date :start_date
      t.date :finish_date
      t.boolean :void, :default => false
      t.integer :last_updated_by_id
      t.integer :qty
      t.string :unit
      t.integer :qty_produced
      t.boolean :completed, :default => false
      t.integer :customer_id
      t.boolean :expedite, :default => false
      t.integer :order_manager_id
      t.date :actual_finish_date
      t.string :wf_state
      t.string :batch_num
      t.integer :sales_id
      
      t.timestamps
    end
    
    add_index :production_orderx_part_productions, :part_name
    add_index :production_orderx_part_productions, :drawing_num
    add_index :production_orderx_part_productions, :batch_num
    add_index :production_orderx_part_productions, :order_manager_id
    add_index :production_orderx_part_productions, :customer_id
    add_index :production_orderx_part_productions, :completed
    add_index :production_orderx_part_productions, :void
    add_index :production_orderx_part_productions, :expedite
    add_index :production_orderx_part_productions, :sales_id
  end
end
