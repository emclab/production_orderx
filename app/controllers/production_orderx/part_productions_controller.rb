require_dependency "production_orderx/application_controller"

module ProductionOrderx
  class PartProductionsController < ApplicationController
    before_action :require_employee
    before_action :load_record
    
    def index
      @title = t('Part Productions')
      @part_productions = params[:production_orderx_part_productions][:model_ar_r]
      @part_productions = @part_productions.where(part_id: @part.id) if @part
      @part_productions = @part_productions.where(order_id: @order.id) if @order
      @part_productions = @part_productions.where(aux_resource: @aux_resource) if @aux_resource
      @part_productions = @part_productions.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('part_production_index_view', 'production_orderx') unless @aux_resource
      @erb_code = find_config_const('part_production_' + @aux_model + '_index_view', 'production_orderx') if @aux_resource
    end
  
    def new
      @title = t('New Part Production')
      @part_production = ProductionOrderx::PartProduction.new()
      @erb_code = find_config_const('part_production_new_view', 'production_orderx') unless @aux_resource
      @erb_code = find_config_const('part_production_' + @aux_model + '_new_view', 'production_orderx') if @aux_resource
      @aux_erb_code = find_config_const(@aux_model + '_new_view', @aux_engine) if @aux_resource  #cob_info_new_view, cob_orderx
      @js_erb_code = find_config_const('part_production_new_js_view', 'production_orderx') 
    end
  
    def create
      @part_production = ProductionOrderx::PartProduction.new(new_params)
      if params[:part_production][:aux_resource].present?
        aux_model = params[:part_production][:aux_resource].strip.sub(/.+\//,'').singularize.to_s
        if params[:part_production][aux_model.to_sym].present?   #fields presented in views
          aux_obj = @part_production.send("build_#{aux_model}")
          params[:part_production][aux_model.to_sym].each do |k, v|
            aux_obj[k.to_sym] = v if v.present? && aux_obj.has_attribute?(k.to_sym)
          end
        end
      end
      @part_production.last_updated_by_id = session[:user_id]
      if @part_production.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('part_production_new_view', 'production_orderx') if params[:part_production][:aux_resource].blank?
        @erb_code = find_config_const('part_production_' + @aux_model + '_new_view', 'production_orderx') if params[:part_production][:aux_resource].present?
        @aux_erb_code = find_config_const(aux_model + '_new_view', @aux_engine) if params[:part_production][:aux_resource].present?
        @js_erb_code = find_config_const('part_production_new_js_view', 'production_orderx') 
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Part Production')
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:id])
      @erb_code = find_config_const('part_production_edit_view', 'production_orderx') unless @aux_resource
      @erb_code = find_config_const('part_production_' + @aux_model + '_edit_view', 'production_orderx') if @aux_resource
      @aux_erb_code = find_config_const(@aux_model + '_edit_view', @aux_engine) if @aux_resource
      @js_erb_code = find_config_const('part_production_edit_js_view', 'production_orderx') 
    end
  
    def update
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:id])
      @part_production.last_updated_by_id = session[:user_id]
      if @aux_resource
        if params[:part_production][@aux_model.to_sym].present? #aux fields presented in views
          aux_obj = @order.send(@aux_model)
          params[:part_production][@aux_model.to_sym].each do |k, v|
            aux_obj[k.to_sym] = v if v.present? && aux_obj.has_attribute?(k.to_sym)
          end
        end
      end
      if @part_production.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('part_production_edit_view', 'production_orderx') unless @aux_resource
        @erb_code = find_config_const('part_production_' + @aux_model + '_edit_view', 'production_orderx') if @aux_resource
        @aux_erb_code = find_config_const(@aux_model + '_edit_view', @aux_engine) if @aux_resource 
        @js_erb_code = find_config_const('part_production_edit_js_view', 'production_orderx')  
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Part Production Info')
      @part_production = ProductionOrderx::PartProduction.find_by_id(params[:id])
      @erb_code = find_config_const('part_production_show_view', 'production_orderx') unless @aux_resource
      @erb_code = find_config_const('part_production_' + @aux_model + '_show_view', 'production_orderx') if @aux_resource
      @aux_erb_code = find_config_const(@aux_model + '_show_view', @aux_engine) if @aux_resource
    end
    
    protected
    def load_record
      @order = ProductionOrderx.order_class.find_by_id(params[:order_id].to_i) if params[:order_id].present?
      @order = ProductionOrderx.order_class.find_by_id(ProductionOrderx::PartProduction.find_by_id(params[:id].to_i).order_id) if params[:id].present?
      @order = ProductionOrderx.order_class.find_by_id(params[:part_production][:order_id].to_i) if params[:part_production].present? && params[:part_production][:order_id].present?
      @part = ProductionOrderx.part_class.find_by_id(params[:part_id].to_i) if params[:part_id].present?
      @part = ProductionOrderx.part_class.find_by_id(ProductionOrderx::PartProduction.find_by_id(params[:id].to_i).part_id) if params[:id].present?
      @aux_resource = params[:aux_resource].strip if params[:aux_resource]  #cob_orderx/cob_orders
      @aux_resource = ProductionOrderx::PartProduction.find_by_id(params[:id]).aux_resource if params[:id].present? 
      @aux_resource = params[:part_production][:aux_resource] if params[:part_productioon] && params[:part_production][:aux_resource].present?
      @aux_resource = session[:aux_resource].strip if session[:aux_resource]   
      @aux_engine = @aux_resource.sub(/\/.+/, '') if @aux_resource  
      @aux_model = @aux_resource.sub(/.+\//,'').singularize.to_s if @aux_resource  #cob_info
    end
    
    private
    def new_params
      params.require(:part_production).permit(:actual_finish_date, :completed, :customer_id, :drawing_num, :expedite, :finish_date, :last_updated_by_id, :order_manager_id, :part_name, 
                    :part_num, :qty, :qty_produced, :requirement, :start_date, :step_status_id, :void, :wf_state, :unit, :batch_num, :sales_id, :spec, :order_id, :part_id)
    end
    
    def edit_params
      params.require(:part_production).permit(:actual_finish_date, :completed, :customer_id, :drawing_num, :expedite, :finish_date, :last_updated_by_id, :order_manager_id, :part_name, 
                    :part_num, :qty, :qty_produced, :requirement, :start_date, :step_status_id, :void, :wf_state, :unit, :batch_num, :sales_id, :spec, :order_id, :part_id)
    end
  end
end
