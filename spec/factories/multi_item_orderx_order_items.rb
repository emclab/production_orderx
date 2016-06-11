FactoryGirl.define do
  factory :multi_item_orderx_order_item, :class => 'MultiItemOrderx::OrderItem' do
    order_id 1
last_updated_by_id 1
qty 1
unit "MyString"
unit_price "9.99"
name "MyString"
spec "MyText"
item_num "MyString"
category_id 1
sub_category_id 1
base_item_id 1
item_note "MyText"
fort_token '123456789'
  end

end
