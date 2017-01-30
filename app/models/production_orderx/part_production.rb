module ProductionOrderx
  class PartProduction < ActiveRecord::Base
    attr_accessor :customer_name, :last_updated_by_name, :step_status_name, :order_manager_name, :sales_name, :field_changed, :coordinator_name, :order_shipping_date,
                  :item_order_qty, :item_qty_in_production, :part_info
       
    model_name = Rails.env.test? ? 'cob_orderx/cob_infos' : Authentify::AuthentifyUtility.find_config_const('aux_resource', Thread.current['fort_token'], 'production_orderx')  #cob_orderx/orders
    model_name.split(',').each do |a|
      has_one a.sub(/.+\//,'').singularize.to_sym, class_name: a.camelize.singularize.to_s, dependent: :destroy, autosave: true
    end if model_name.present?
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :step_status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :coordinator, :class_name => 'Authentify::User'
    belongs_to :order, :class_name => ProductionOrderx.order_class.to_s
    belongs_to :part, :class_name => ProductionOrderx.part_class.to_s
    has_many :production_steps, :class_name => 'ProductionOrderx::ProductionStep'
    
    validates :part_name, :qty, :start_date, :finish_date, :fort_token, :presence => true 
    validates :qty, :numericality => {:greater_than => 0}
    validates :coordinator_id, :numericality => {:greater_than => 0}, :if => 'coordinator_id.present?'
    validates :order_id, :numericality => {:greater_than => 0}, :if => 'order_id.present?'
    validates :part_id, :numericality => {:greater_than => 0}, :if => 'part_id.present?'
    validates :qty_produced, :numericality => {:greater_than_or_equal_to => 0}, :if => 'qty_produced.present?'
    #validates :material_cost, :numericality => {:greater_than_or_equal_to => 0}, :if => 'material_cost.present?'
    
    validate :dynamic_validate 
    
    default_scope {where(fort_token: Thread.current[:fort_token])}
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_part_production', self.fort_token, 'production_orderx')
      eval(wf) if wf.present?
    end
    
    def cal_cost_total
      total = 0.00
      total += material_cost if material_cost.present?
      ProductionStep.where(part_production_id: self.id).each do |r|
        total += r.operators.inject(0){|s, a| s + a.hours_spent * a.hourly_rate}
      end
      return total
    end
    
  end
end
