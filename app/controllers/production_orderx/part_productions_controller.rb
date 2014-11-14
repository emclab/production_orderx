require_dependency "production_orderx/application_controller"

module ProductionOrderx
  class PartProductionsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Part Productions')
      @part_productions = params[:production_orderx_part_productions][:model_ar_r]
      @part_productions = @part_productions.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('part_production_index_view', 'production_orderx')
    end
  
    def new
      @title = t('New Part Production')
      @part_production = ProductionOrderx::PartProduction.new()
      @erb_code = find_config_const('part_production_new_view', 'production_orderx')
    end
  
    def create
      @part_production = ProductionOrderx::PartProduction.new(params[:part_production], :as => :role_new)
      @part_production.last_updated_by_id = session[:user_id]
      if @part_production.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('part_production_new_view', 'production_orderx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Part Production')
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:id])
      @erb_code = find_config_const('part_production_edit_view', 'production_orderx')
    end
  
    def update
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:id])
      @part_production.last_updated_by_id = session[:user_id]
      if @part_production.update_attributes(params[:part_production], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('part_production_edit_view', 'production_orderx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Part Production Info')
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:id])
      @erb_code = find_config_const('part_production_show_view', 'production_orderx')
    end
    
    protected
    def load_record
      
    end
  end
end
