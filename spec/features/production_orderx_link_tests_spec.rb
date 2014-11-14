require 'spec_helper'

describe "LinkTests" do
  mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "ProductionOrderx::PartProduction.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.order_manager_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.order_manager_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_order', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'user_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'create_order', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "ProductionOrderx::PartProduction.scoped.order('id')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      
      
      @status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'mfg_status', :name => 'started')
      @b = FactoryGirl.create(:production_orderx_part_production,  :qty_produced => 500)
      log = FactoryGirl.create(:commonx_log, :resource_name => 'production_orderx_production_steps', :resource_id => @b.id)
      @step = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @b.id, :step_status_id => @status.id)
        
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    
  describe "GET /mfg_Part Productionx_link_tests" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit part_productions_path
      #save_and_open_page
      page.should have_content('Part Productions')
      click_link "Edit"
      page.should have_content('Update Part Production')
      fill_in 'part_production_part_name', :with => 'updated part name'
      click_button 'Save'
      visit part_productions_path
      page.should have_content('updated part name')
      #bad data
      visit part_productions_path
      click_link "Edit"
      fill_in 'part_production_part_name', :with => nil
      fill_in 'part_production_drawing_num', :with => 'updated drawing#'
      click_button 'Save'
      visit part_productions_path
      page.should_not have_content('updated drawing#')
      
      visit part_productions_path
      save_and_open_page
      click_link @b.id.to_s
      page.should have_content('Part Production Info')
      #
      visit part_productions_path
      click_link @b.id.to_s
      click_link 'New Log'
      page.should have_content('Log')
      visit part_productions_path()
      #save_and_open_page
      click_link 'New Part Production'
      #save_and_open_page
      page.should have_content('New Part Production')
      fill_in 'part_production_part_name', :with => 'a new name just added'
      fill_in 'part_production_qty', :with => 10
      fill_in 'part_production_start_date', :with => Date.today
      fill_in 'part_production_finish_date', :with => Date.today + 10.days
      save_and_open_page
      click_button  'Save'
      visit part_productions_path
      page.should have_content('a new name just added')
      #bad data
      visit part_productions_path()
      click_link 'New Part Production'
      fill_in 'part_production_part_name', :with => 'a bad new name'
      fill_in 'part_production_qty', :with => 0
      fill_in 'part_production_start_date', :with => Date.today
      fill_in 'part_production_finish_date', :with => Date.today + 10.days
      click_button 'Save'
      visit part_productions_path
      page.should_not have_content('a bad new name')
    end
    
    it "works for production step" do
      visit production_steps_path(part_production_id: @b.id)
      save_and_open_page
      page.should have_content('Production Steps')
      #save_and_open_page
      page.should have_content('Next Step')
      click_link 'Next Step'
      fill_in 'production_step_qty_in', :with => 1001
      select('started', :from => 'production_step_step_status_id')
      select('green', :from => 'production_step_ontime_indicator')
      click_button 'Save'
      visit production_steps_path(part_production_id: @b.id)
      page.should have_content(1001)
      #save_and_open_page
      
      visit production_steps_path
      #save_and_open_page
      page.should have_content('Production Steps')
      click_link "Production Steps"
      #save_and_open_page
      page.should have_content('Edit')
      click_link 'Edit'
      #save_and_open_page
    end
  end
end
