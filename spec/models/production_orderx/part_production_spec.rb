require 'spec_helper'

module ProductionOrderx
  describe PartProduction do
    it "should be OK" do
      c = FactoryGirl.create(:production_orderx_part_production)
      c.should be_valid
    end
    
    it "should reject nil part_name" do
      c = FactoryGirl.build(:production_orderx_part_production, :part_name => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 qty" do
      c = FactoryGirl.build(:production_orderx_part_production, :qty => 0)
      c.should_not be_valid
    end
    
   it "should reject nil finish date" do
      c = FactoryGirl.build(:production_orderx_part_production, :finish_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil start_date" do
      c = FactoryGirl.build(:production_orderx_part_production, :start_date => nil)
      c.should_not be_valid
    end
    
    
  end
end
