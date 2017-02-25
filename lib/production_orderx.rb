require "production_orderx/engine"

module ProductionOrderx
  mattr_accessor :part_class, :order_class
  
  def self.part_class
    @@part_class.constantize
  end
  
  def self.order_class
    @@order_class.constantize
  end
 
end
