require_dependency "production_orderx/application_controller"

module ProductionOrderx
  class OperatorsController < ApplicationController
    before_action :require_employee
    before_action :load_record
    after_action :info_logger, :except => [:new, :edit, :event_action_result, :wf_edit_result, :search_results, :stats_results, :acct_summary_result]
    
    def index
      @title = t('Operators')
      @operators = params[:production_orderx_operators][:model_ar_r]
      @operators = @operators.where(production_step_id: @production_step.id) if @production_step
      @operators = @operators.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('operator_index_view', session[:fort_token], 'production_orderx') if session[:user_role_flag].blank?
      @erb_code = find_config_const('operator_index_view_' + session[:user_role_flag].strip, session[:fort_token], 'production_orderx') if session[:user_role_flag].present?
      @erb_code = find_config_const('operator_index_view', session[:fort_token], 'production_orderx') if @erb_code.blank? && session[:user_role_flag].present? 
    end

    def new
      @title = t('New Operator')
      @operator = ProductionOrderx::Operator.new()
      @erb_code = find_config_const('operator_new_view', 'production_orderx')
    end

    def create
      @operator = ProductionOrderx::Operator.new(new_params)
      @operator.last_updated_by_id = session[:user_id]
      @operator.fort_token = session[:fort_token]
      if @operator.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('operator_new_view', session[:fort_token], 'production_orderx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'      
      end
    end

    def edit
      @title = t('Update Operator')
      @operator = ProductionOrderx::Operator.find_by_id(params[:id])
      @erb_code = find_config_const('operator_edit_view', session[:fort_token], 'production_orderx') 
    end

    def update
      @operator = ProductionOrderx::Operator.find_by_id(params[:id])
      @operator.last_updated_by_id = session[:user_id]
      if @operator.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('operator_edit_view', session[:fort_token], 'production_orderx')  
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end

    def show
      @title = t('Operator Info')
      @operator = ProductionOrderx::Operator.find_by_id(params[:id])
      @erb_code = find_config_const('operator_show_view', session[:fort_token], 'production_orderx') 
    end

    def destroy
      ProductionOrderx::Operator.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    def load_record
      @production_step = ProductionOrderx::ProductionStep.find_by_id(params[:production_step_id]) if params[:production_step_id].present?
      @production_step = ProductionOrderx::ProductionStep.find_by_id(ProductionOrderx::Operator.find_by_id(params[:id]).production_step_id) if params[:id].present?
      @production_step = ProductionOrderx::ProductionStep.find_by_id(params[:operator][:production_step_id].to_i) if params[:operator] && params[:operator][:production_step_id].present?
    end
    
    private 
    def new_params
      params.require(:operator).permit(:brief_note, :name, :production_step_id, :hours_spent, :hourly_rate, :hr_id)
    end
    
    def edit_params
      params.require(:operator).permit(:brief_note, :name, :production_step_id, :hours_spent, :hourly_rate, :hr_id)
    end
  end
end
