require 'rails_helper'

module ProductionOrderx
  RSpec.describe Operator, type: :model do
    it "should be OK" do
      c = FactoryGirl.create(:production_orderx_operator)
      expect(c).to be_valid
    end
    
    it "should reject 0 production_step_id" do
      c = FactoryGirl.build(:production_orderx_operator, :production_step_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:production_orderx_operator, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil token" do
      c = FactoryGirl.build(:production_orderx_operator, :fort_token => nil)
      expect(c).not_to be_valid
    end
    
    it "should take 0 qty out" do
      c = FactoryGirl.build(:production_orderx_operator, :hourly_rate => 0)
      expect(c).to be_valid
    end
    
    it "should reject 0 hours_spent" do
      c = FactoryGirl.build(:production_orderx_operator, :hours_spent => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject dup name" do
      c1 = FactoryGirl.create(:production_orderx_operator, :name => 'name')
      c = FactoryGirl.build(:production_orderx_operator, :name => 'nAme')
      expect(c).not_to be_valid
    end
    
    it "should take dup name if fort tokens are different" do
      c1 = FactoryGirl.create(:production_orderx_operator)
      c = FactoryGirl.build(:production_orderx_operator, :fort_token => 'nAme')
      expect(c).to be_valid
    end

    
  end
end
