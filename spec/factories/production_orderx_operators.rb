FactoryGirl.define do
  factory :production_orderx_operator, class: 'ProductionOrderx::Operator' do
    name "MyString"
    hr_id 1
    hours_spent "9.99"
    last_updated_by_id 1
    hourly_rate "9.99"
    fort_token "123456789"
    brief_note "MyText"
    production_step_id 1
  end
end
