require 'rails_helper'

module ProductionOrderx
  RSpec.describe PartProduction, type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:production_orderx_part_production)
      expect(c).to be_valid
    end
    
    it "should reject nil part_name" do
      c = FactoryGirl.build(:production_orderx_part_production, :part_name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil token" do
      c = FactoryGirl.build(:production_orderx_part_production, :fort_token => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 qty" do
      c = FactoryGirl.build(:production_orderx_part_production, :qty => 0)
      expect(c).not_to be_valid
    end
    
   it "should reject nil finish date" do
      c = FactoryGirl.build(:production_orderx_part_production, :finish_date => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil start_date" do
      c = FactoryGirl.build(:production_orderx_part_production, :start_date => nil)
      expect(c).not_to be_valid
    end
    
    
  end
end
