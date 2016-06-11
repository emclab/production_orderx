require_dependency "production_orderx/application_controller"

module ProductionOrderx
  class ProductionStepsController < ApplicationController
    protect_from_forgery :except => [:new, :edit]
    before_action :require_employee
    before_action :load_record
    after_action :info_logger, :except => [:new, :edit, :event_action_result, :wf_edit_result, :search_results, :stats_results, :acct_summary_result]
    
    def index
      @title = I18n.t('Production Steps')
      @production_steps = params[:production_orderx_production_steps][:model_ar_r]
      @production_steps = @part_production.production_steps 
      @production_steps = @production_steps.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('production_step_index_view', session[:fort_token], 'production_orderx')
    end
  
    def new
      @title = I18n.t('New Production Step')
      @production_step = ProductionOrderx::ProductionStep.new()
      @erb_code = find_config_const('production_step_new_view', session[:fort_token], 'production_orderx')
    end
  
    def create
      @production_step = ProductionOrderx::ProductionStep.new(new_params)
      @production_step.last_updated_by_id = session[:user_id]
      @production_step.fort_token = session[:fort_token]
      if @production_step.save
        redirect_to production_steps_path(part_production_id: @production_step.part_production_id), :notice => I18n.t('Successfully Saved!') #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @part_production = ProductionOrderx::PartProduction.find_by_id(params[:production_step][:part_production_id]) if params[:production_step].present? && params[:production_step][:part_production_id].present?
        flash[:notice] = I18n.t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = I18n.t('Update Production Step')
      @production_step = ProductionOrderx::ProductionStep.find_by_id(params[:id])
      @erb_code = find_config_const('production_step_edit_view', session[:fort_token], 'production_orderx')
    end
  
    def update
      @production_step = ProductionOrderx::ProductionStep.find_by_id(params[:id])
      @production_step.last_updated_by_id = session[:user_id]
      if @production_step.update_attributes(edit_params)
        redirect_to production_steps_path(part_production_id: @production_step.part_production_id), :notice => I18n.t('Successfully Updated!') #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = I18n.t('Data Error. Not Updated!')
        render 'edit'
      end
    end
    
    protected
    def load_record
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:part_production_id]) if params[:part_production_id].present?
      @part_production = ProductionOrderx::PartProduction.find_by_id(ProductionOrderx::ProductionStep.find_by_id(params[:id]).part_production_id) if params[:id].present?
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:production_step][:part_production_id].to_i) if params[:production_step] && params[:production_step][:part_production_id].present?
    end
    
    private 
    def new_params
      params.require(:production_step).permit(:brief_note, :ontime_indicator, :part_production_id, :qty_in, :qty_out, :step_status_id, :start_time, :finish_time)
    end
    
    def edit_params
      params.require(:production_step).permit(:brief_note, :ontime_indicator, :qty_in, :qty_out, :step_status_id, :start_time, :finish_time)
    end
  end
end
