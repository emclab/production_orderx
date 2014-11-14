module ProductionOrderx
  class PartProduction < ActiveRecord::Base
    attr_accessor :customer_name, :last_updated_by_name, :step_status_name, :order_manager_name
    attr_accessible :actual_finish_date, :completed, :customer_id, :drawing_num, :expedite, :finish_date, :last_updated_by_id, :order_manager_id, :part_name, 
                    :part_num, :qty, :qty_produced, :requirement, :start_date, :step_status_id, :void, :wf_state, :unit, :batch_num,
                    :as => :role_new
    attr_accessible :actual_finish_date, :completed, :customer_id, :drawing_num, :expedite, :finish_date, :last_updated_by_id, :order_manager_id, :part_name, 
                    :part_num, :qty, :qty_produced, :requirement, :start_date, :step_status_id, :void, :wf_state, :unit, :batch_num,
                    :as => :role_update
                                    
    attr_accessor :customer_id_s, :start_date_s, :end_date_s, :time_frame_s, :part_name_s, :drawing_num_s, :part_num_s, :expedite_s, :completed_s, :o_start_date_s, 
                  :o_finish_date_s, :batch_num_s
    attr_accessible :customer_id_s, :start_date_s, :end_date_s, :time_frame_s, :part_name_s, :drawing_num_s, :part_num_s, :expedite_s, :completed_s, :o_start_date_s, 
                    :o_finish_date_s, :batch_num_s,
                    :as => :role_search_stats
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :step_status, :class_name => 'Commonx::MiscDefinition'
    has_many :production_steps, :class_name => 'ProductionOrderx::ProductionStep'
    
    validates :part_name, :qty, :start_date, :finish_date, :presence => true 
    validates :qty, :numericality => {:greater_than => 0}
    validates :order_manager_id, :numericality => {:greater_than => 0}, :if => 'order_manager_id.present?'
    validates :qty_produced, :numericality => {:greater_than_or_equal_to => 0}, :if => 'qty_produced.present?'
    
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_production_order', 'production_orderx')
      eval(wf) if wf.present?
    end
  end
end
