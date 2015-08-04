module ProductionOrderx
  class PartProduction < ActiveRecord::Base
    attr_accessor :customer_name, :last_updated_by_name, :step_status_name, :order_manager_name, :sales_name, :sales_name, :coordinator_name
=begin
    attr_accessible :actual_finish_date, :completed, :customer_id, :drawing_num, :expedite, :finish_date, :last_updated_by_id, :order_manager_id, :part_name, 
                    :part_num, :qty, :qty_produced, :requirement, :start_date, :step_status_id, :void, :wf_state, :unit, :batch_num, :sales_id,
                    :as => :role_new
    attr_accessible :actual_finish_date, :completed, :customer_id, :drawing_num, :expedite, :finish_date, :last_updated_by_id, :order_manager_id, :part_name, 
                    :part_num, :qty, :qty_produced, :requirement, :start_date, :step_status_id, :void, :wf_state, :unit, :batch_num, :sales_id, :sales_name,
                    :as => :role_update
                                    
    attr_accessor :customer_id_s, :start_date_s, :end_date_s, :time_frame_s, :part_name_s, :drawing_num_s, :part_num_s, :expedite_s, :completed_s, :o_start_date_s, 
                  :o_finish_date_s, :batch_num_s, :sales_id_s
    attr_accessible :customer_id_s, :start_date_s, :end_date_s, :time_frame_s, :part_name_s, :drawing_num_s, :part_num_s, :expedite_s, :completed_s, :o_start_date_s, 
                    :o_finish_date_s, :batch_num_s, :sales_id_s,
                    :as => :role_search_stats
=end              
    model_name = Rails.env.test? ? 'cob_orderx/cob_infos' : Authentify::AuthentifyUtility.find_config_const('aux_resource', 'production_orderx')  #cob_orderx/orders
    model_name.split(',').each do |a|
      has_one a.sub(/.+\//,'').singularize.to_sym, class_name: a.camelize.singularize.to_s, dependent: :destroy, autosave: true
    end if model_name.present?
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :step_status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :coordinator, :class_name => 'Authentify::User'
    belongs_to :order, :class_name => ProductionOrderx.order_class.to_s
    belongs_to :part, :class_name => ProductionOrderx.part_class.to_s
    has_many :production_steps, :class_name => ProductionOrderx.production_step_class.to_s
    
    validates :part_name, :qty, :start_date, :finish_date, :presence => true 
    validates :qty, :numericality => {:greater_than => 0}
    validates :coordinator_id, :numericality => {:greater_than => 0}, :if => 'coordinator_id.present?'
    validates :order_id, :numericality => {:greater_than => 0}, :if => 'order_id.present?'
    validates :part_id, :numericality => {:greater_than => 0}, :if => 'part_id.present?'
    validates :qty_produced, :numericality => {:greater_than_or_equal_to => 0}, :if => 'qty_produced.present?'
    
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_part_production', 'production_orderx')
      eval(wf) if wf.present?
    end
  end
end
