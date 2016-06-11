FactoryGirl.define do
  factory :multi_item_orderx_order, :class => 'MultiItemOrderx::Order' do
    order_num "MyString"
    last_updated_by_id 1
    sales_id 1
    wf_state "MyString"
    customer_id 1
    order_date "2015-06-27"
    brief_note "MyText"
    order_total "9.99"
    shipping_cost "9.99"
    tax "9.99"
    other_cost "9.99"
    category_id 1
    #sub_category_id 1
    shipping_date "2015-06-27"
    actual_delivery_date "2015-06-27"
    void false
    currency "MyString"
    #executed_total_amount "9.99"
    approved false
    approved_date "2015-06-27"
    approved_by_id 1
    shipping_origin "MyString"
    delivery_date "2015-06-27"
    completed false
    order_requirement 'requirement goes here'
    entered_by_id 1
    fort_token '123456789'
  end

end
