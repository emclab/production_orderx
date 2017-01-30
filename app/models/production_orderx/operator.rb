module ProductionOrderx
  class Operator < ActiveRecord::Base
    
    default_scope {where(fort_token: Thread.current[:fort_token])}
    
    attr_accessor :last_updated_by_name, :step_status_name
     
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :production_step, :class_name => 'ProductionOrderx::ProductionStep'
    belongs_to :hr, :class_name => ProductionOrderx.human_resource_class.to_s
    
    validates :name, :fort_token, :presence => true 
    validates :name, :uniqueness => {:scope => [:production_step_id, :fort_token], :case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :hours_spent, :numericality => {:greater_than => 0}, :if => 'hours_spent.present?'
    validates :hourly_rate, :numericality => {:greater_than_and_equal_to => 0}, :if => 'hourly_rate.present?'
    validates :production_step_id, :numericality => {:greater_than => 0}
    validates :hr_id, :numericality => {:greater_than => 0}, :if => 'hr_id.present?'
    
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_operator', self.fort_token, 'production_orderx')
      eval(wf) if wf.present?
    end
    
    def cal_total
      return hours_spent * hourly_rate if hours_spent.present? && hourly_rate.present?
      return 0.00
    end
  end
end
