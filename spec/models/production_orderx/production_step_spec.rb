require 'rails_helper'

module ProductionOrderx
  RSpec.describe ProductionStep, type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:production_orderx_production_step)
      expect(c).to be_valid
    end
    
    it "should reject 0 part production_id" do
      c = FactoryGirl.build(:production_orderx_production_step, :part_production_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject nil qty" do
      c = FactoryGirl.build(:production_orderx_production_step, :qty_in => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil token" do
      c = FactoryGirl.build(:production_orderx_production_step, :fort_token => nil)
      expect(c).not_to be_valid
    end
    
    it "should take 0 qty out" do
      c = FactoryGirl.build(:production_orderx_production_step, :qty_out => 0)
      expect(c).to be_valid
    end
    
    it "should reject nil step_status_id" do
      c = FactoryGirl.build(:production_orderx_production_step, :step_status_id => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject dup step_status_id" do
      c1 = FactoryGirl.create(:production_orderx_production_step)
      c = FactoryGirl.build(:production_orderx_production_step)
      expect(c).not_to be_valid
    end
    
    it "should rejectnil ontime_indicator" do
      c = FactoryGirl.build(:production_orderx_production_step, :ontime_indicator => nil)
      expect(c).not_to be_valid
    end
  end
end
