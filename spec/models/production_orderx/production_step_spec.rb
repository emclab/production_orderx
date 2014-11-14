require 'spec_helper'

module ProductionOrderx
  describe ProductionStep do
    it "should be OK" do
      c = FactoryGirl.create(:production_orderx_production_step)
      c.should be_valid
    end
    
    it "should reject 0 part production_id" do
      c = FactoryGirl.build(:production_orderx_production_step, :part_production_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil qty" do
      c = FactoryGirl.build(:production_orderx_production_step, :qty_in => nil)
      c.should_not be_valid
    end
    
    it "should take 0 qty out" do
      c = FactoryGirl.build(:production_orderx_production_step, :qty_out => 0)
      c.should be_valid
    end
    
    it "should reject nil step_status_id" do
      c = FactoryGirl.build(:production_orderx_production_step, :step_status_id => nil)
      c.should_not be_valid
    end
    
    it "should reject dup step_status_id" do
      c1 = FactoryGirl.create(:production_orderx_production_step)
      c = FactoryGirl.build(:production_orderx_production_step)
      c.should_not be_valid
    end
    
    it "should rejectnil ontime_indicator" do
      c = FactoryGirl.build(:production_orderx_production_step, :ontime_indicator => nil)
      c.should_not be_valid
    end
  end
end
