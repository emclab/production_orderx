require_dependency "production_orderx/application_controller"

module ProductionOrderx
  class ProductionStepsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Production Steps')
      @production_steps = params[:production_orderx_production_steps][:model_ar_r]
      @production_steps = @part_production.production_steps if @part_production
      @production_steps = @production_steps.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('production_step_index_view', 'production_orderx')
    end
  
    def new
      @title = t('New Step Qty')
      @production_step = ProductionOrderx::ProductionStep.new()
      @erb_code = find_config_const('production_step_new_view', 'production_orderx')
    end
  
    def create
      @production_step = ProductionOrderx::ProductionStep.new(params[:production_step], :as => :role_new)
      @production_step.last_updated_by_id = session[:user_id]
      if @production_step.save
        redirect_to production_steps_path(part_production_id: @production_step.part_production_id), :notice => t('Successfully Saved!') #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @part_production = ProductionOrderx::PartProduction.find_by_id(params[:production_step][:part_production_id]) if params[:production_step].present? && params[:production_step][:part_production_id].present?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Step Qty')
      @production_step = ProductionOrderx::ProductionStep.find_by_id(params[:id])
      @erb_code = find_config_const('production_step_edit_view', 'production_orderx')
    end
  
    def update
      @production_step = ProductionOrderx::ProductionStep.find_by_id(params[:id])
      @production_step.last_updated_by_id = session[:user_id]
      if @production_step.update_attributes(params[:production_step], :as => :role_update)
        redirect_to production_steps_path(part_production_id: @production_step.part_production_id), :notice => t('Successfully Updated!') #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    protected
    def load_record
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:part_production_id]) if params[:part_production_id].present?
      @part_production = ProductionOrderx::PartProduction.find_by_id(ProductionOrderx::ProductionStep.find_by_id(params[:id]).part_production_id) if params[:id].present?
    end
  end
end
