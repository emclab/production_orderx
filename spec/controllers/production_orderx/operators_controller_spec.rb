require 'rails_helper'

module ProductionOrderx
  RSpec.describe OperatorsController, type: :controller do
    routes {ProductionOrderx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      config_entry = FactoryGirl.create(:engine_config, :engine_name => 'rails_app', :engine_version => nil, :argument_name => 'SESSION_TIMEOUT_MINUTES', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @batch = FactoryGirl.create(:production_orderx_production_step)
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids 
      session[:fort_token] = @u.fort_token 
    end
    
    render_views
  
    describe "GET 'index'" do
      it "returns all operators" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProductionOrderx::Operator.order('id')")
        session[:user_id] = @u.id
        o = FactoryGirl.create(:production_orderx_operator, :production_step_id => @batch.id)
        o1 = FactoryGirl.create(:production_orderx_operator, :production_step_id => @batch.id, :name => 'a new name')
        get 'index', {:production_step_id => @batch.id}
        expect(assigns(:operators)).to match_array([o, o1])
      end
            
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        get 'new', {:production_step_id => @batch.id}
        expect(response).to be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.attributes_for(:production_orderx_operator, :production_step_id => @batch.id)
        get 'create', {:operator => q}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.attributes_for(:production_orderx_operator, :name => nil)
        get 'create', {operator: q }
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:production_orderx_operator, :production_step_id => @batch.id)
        get 'edit', {:id => q.id}
        expect(response).to be_success
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:production_orderx_operator, :production_step_id => @batch.id)
        get 'update', {:id => q.id, :operator => {:brief_note => 'steel 201'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:production_orderx_operator, :production_step_id => @batch.id)
        get 'update', {:id => q.id, :operator => {:name => nil}}
        expect(response).to render_template('edit')
      end
    end
    
    describe "GET #show" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:production_orderx_operator, :production_step_id => @batch.id)
        get 'show', {:id => q.id}
        expect(response).to be_success
      end
    end
    
    describe "GET #destroy" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'production_orderx_operators', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:production_orderx_operator, :production_step_id => @batch.id)
        get 'destroy', {:id => q.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
      end
    end

  end
end