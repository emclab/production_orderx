require "production_orderx/engine"

module ProductionOrderx
  mattr_accessor :production_step_class, :part_class, :order_class, :part_production_class
  
  def self.production_step_class
    @@production_step_class.constantize
  end
  
  def self.part_class
    @@part_class.constantize
  end
  
  def self.order_class
    @@order_class.constantize
  end
  
  def self.part_production_class
    @@part_production_class.constantize
  end
end
