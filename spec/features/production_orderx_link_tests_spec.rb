require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
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
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
         'left-span#'         => '6', 
         'offset#'         => '2',
         'form-span#'         => '4'
        }
    before(:each) do
      FactoryGirl.create(:engine_config, :engine_name => 'rails_app', :engine_version => nil, :argument_name => 'enable_info_logger', :argument_value => 'true')
      config_entry = FactoryGirl.create(:engine_config, :engine_name => 'rails_app', :engine_version => nil, :argument_name => 'SESSION_TIMEOUT_MINUTES', :argument_value => 30)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password1', :password_confirmation => 'password1')
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "ProductionOrderx::PartProduction.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.coordinator_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'production_orderx_part_productions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.coordinator_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_order', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'user_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'create_order', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "ProductionOrderx::PartProduction.order('id')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      #op
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "ProductionOrderx::Operator.order('id')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "", :masked_attrs => '-hourly_cost')
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      
      @status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'mfg_status', :name => 'started')
      @b = FactoryGirl.create(:production_orderx_part_production,  :qty_produced => 500)
      log = FactoryGirl.create(:commonx_log, :resource_name => 'production_orderx_production_steps', :resource_id => @b.id)
      @step = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @b.id, :step_status_id => @status.id)
      @op = FactoryGirl.create(:production_orderx_operator, :production_step_id => @step.id, :name => 'op1')
        
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    
  describe "GET /mfg_Part Productionx_link_tests" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit production_orderx.part_productions_path
      expect(Authentify::SysLog.all.count).to eq(1)
      expect(Authentify::SysLog.all.first.resource).to eq('production_orderx/part_productions')
      expect(Authentify::SysLog.all.first.user_id).to eq(@u.id)
     
      #save_and_open_page
      expect(page).to have_content('Part Productions')
      click_link "Edit"
      expect(page).to have_content('Update Part Production')
      fill_in 'part_production_part_name', :with => 'updated part name'
      click_button 'Save'
      visit production_orderx.part_productions_path
      expect(page).to have_content('updated part name')
      #bad data
      visit production_orderx.part_productions_path
      click_link "Edit"
      fill_in 'part_production_part_name', :with => nil
      fill_in 'part_production_drawing_num', :with => 'updated drawing#'
      click_button 'Save'
      visit production_orderx.part_productions_path
      expect(page).not_to have_content('updated drawing#')
      
      visit production_orderx.part_productions_path
      #save_and_open_page
      click_link @b.batch_num.to_s
      expect(page).to have_content('Part Production Info')
      #
      visit production_orderx.part_productions_path
      click_link @b.batch_num.to_s
      click_link 'New Log'
      expect(page).to have_content('Log')
      visit production_orderx.part_productions_path()
      #save_and_open_page
      click_link 'New Part Production'
      #save_and_open_page
      expect(page).to have_content('New Part Production')
      fill_in 'part_production_part_name', :with => 'a new name just added'
      fill_in 'part_production_qty', :with => 10
      fill_in 'part_production_start_date', :with => Date.today
      fill_in 'part_production_finish_date', :with => Date.today + 10.days
      #save_and_open_page
      click_button  'Save'
      visit production_orderx.part_productions_path
      expect(page).to have_content('a new name just added')
      #bad data
      visit production_orderx.part_productions_path()
      click_link 'New Part Production'
      fill_in 'part_production_part_name', :with => 'a bad new name'
      fill_in 'part_production_qty', :with => 0
      fill_in 'part_production_start_date', :with => Date.today
      fill_in 'part_production_finish_date', :with => Date.today + 10.days
      click_button 'Save'
      visit production_orderx.part_productions_path
      expect(page).not_to have_content('a bad new name')
    end
    
    it "works for production step" do
      visit production_orderx.production_steps_path(part_production_id: @b.id)
      expect(page).to have_content('Production Steps')
      expect(Authentify::SysLog.all.count).to eq(1)
      expect(Authentify::SysLog.all.first.resource).to eq('production_orderx/production_steps')
      expect(Authentify::SysLog.all.first.user_id).to eq(@u.id)
      #save_and_open_page
      expect(page).to have_content('Next Step')
      click_link 'Next Step'
      #save_and_open_page
     # fill_in 'production_step_qty_in', :with => 1001
      #select('started', :from => 'production_step_step_status_id')
      #select('green', :from => 'production_step_ontime_indicator')
      #click_button 'Save'
      #visit production_orderx.production_steps_path(part_production_id: @b.id)
      #expect(page).to have_content(1001)
      #save_and_open_page
      
      visit production_orderx.production_steps_path(part_production_id: @b.id)
      #save_and_open_page
      expect(page).to have_content('Production Steps')
      click_link "Edit"
      #save_and_open_page
      expect(page).to have_content('Update Production Step')
      #save_and_open_page
      #fill_in 'production_step_brief_note', with: 'a new stuff'
      #visit production_orderx.production_steps_path(part_production_id: @b.id)
      #expect(page).should have_content('a new stuff')
    end
    
    it "works for operators" do
      FactoryGirl.create(:commonx_misc_definition, :for_which => 'hr_name_list', :name => 'op1')
      
      visit production_orderx.operators_path(production_step_id: @step.id)
      expect(page).to have_content('Operators')
      #show
      click_link @op.name
      #edit
      visit production_orderx.operators_path(production_step_id: @step.id)
      click_link 'Edit'
      #save_and_open_page
      fill_in 'operator_hours_spent', with: 101
      select 'op1', from: 'operator_name'
      click_button 'Save'
      visit production_orderx.operators_path(production_step_id: @step.id)
      #save_and_open_page
      expect(page).to have_content('101')
      #
      click_link('New Operator')
      expect(page).not_to have_content('Hourly Cost($)')
      select('op1', from: 'operator_name')
      fill_in 'operator_hours_spent', with: 10
      click_button 'Save'    
      #
      
    end
  end
end
