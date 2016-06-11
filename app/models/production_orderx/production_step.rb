module ProductionOrderx
  class ProductionStep < ActiveRecord::Base
    attr_accessor :step_status_name, :field_changed
    

    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :part_production, :class_name => ProductionOrderx.part_production_class.to_s 
    belongs_to :step_status, :class_name => 'Commonx::MiscDefinition'  
    
    validates :ontime_indicator, :fort_token, :presence => true
    validates :part_production_id, :step_status_id, :presence => true,
                                                    :numericality => {:greater_than => 0}
    validates :qty_in, :presence => true,
                    :numericality => {:greater_than => 0, :message => I18n.t('Qty >= 0')}    
    validates :step_status_id, :uniqueness => {:scope => :part_production_id, :message => I18n.t('Duplicate step!')} 
    validates :qty_out, :numericality => {:greater_than_or_equal_to => 0, :message => I18n.t('Qty >= 0')}, :if => 'qty_out.present?'   
    
    default_scope {where(fort_token: Thread.current[:fort_token])}
  end
end
