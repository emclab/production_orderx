require 'spec_helper'

module ProductionOrderx
  describe ProductionStepsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'mfg_batch_status', :name => 'started')
      @status1 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'mfg_batch_status', :name => 'started cutting')
      @batch = FactoryGirl.create(:production_orderx_part_production)
        
    end
    
    render_views
  
    describe "GET 'index'" do
      it "returns all step qties" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProductionOrderx::ProductionStep.scoped.order('id')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status.id)
        o1 = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status1.id)
        get 'index', {:use_route => :production_orderx, :part_production_id => @batch.id}
        assigns(:production_steps).should =~ [o, o1]
      end
      
      it "should return step qties for the batch" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProductionOrderx::ProductionStep.scoped.order('id')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status.id)
        o1 = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status1.id)
        get 'index', {:use_route => :production_orderx, :part_production_id => @batch.id}
        assigns(:production_steps).should =~ [o1, o]
      end
      
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :production_orderx, :part_production_id => @batch.id}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status.id)
        get 'create', {:use_route => :production_orderx, :production_step => q}
        response.should redirect_to production_steps_path(part_production_id: @batch.id)
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:production_orderx_production_step, :part_production_id => nil)
        get 'create', {:use_route => :production_orderx, :part_production_id => @batch.id }
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status.id)
        get 'edit', {:use_route => :production_orderx, :id => q.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status.id)
        get 'update', {:use_route => :production_orderx, :id => q.id, :production_step => {:brief_note => 'steel 201'}}
        response.should redirect_to production_steps_path(part_production_id: @batch.id)
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'production_orderx_production_steps', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:production_orderx_production_step, :part_production_id => @batch.id, :step_status_id => @status.id)
        get 'update', {:use_route => :production_orderx, :id => q.id, :production_step => {:qty_in => nil}}
        response.should render_template('edit')
      end
    end
  end
end
