class EntitiesListsController < ApplicationController
  before_action :set_agent
  before_action :check_user_rights
  before_action :set_entities_list, except: [:new, :create]

  def new
    @entities_list = EntitiesList.new
    @form_model = [current_user, @agent, @entities_list]
    render partial: 'new'
  end

  def create
    @entities_list = EntitiesList.new(entities_list_params)
    @entities_list.agent = @agent
    respond_to do |format|
      if @entities_list.save
        format.json do
          redirect_to user_agent_path(current_user, @agent), notice: t('views.entities_lists.new.success_message')
        end
      else
        format.json do
          render json: {
            replace_modal_content_with: render_to_string(partial: 'new', formats: :html)
          }, status: 422
        end
      end
    end
  end

  def edit
    @form_model = @entities_list
    render partial: 'edit'
  end

  def update
    respond_to do |format|
      if @entities_list.update(entities_list_params)
        format.json {
          redirect_to user_agent_path(current_user, @agent), notice: t('views.entities_lists.edit.success_message')
        }
      else
        format.json {
          render json: {
            replace_modal_content_with: render_to_string(partial: 'edit', formats: :html),
          }, status: 422
        }
      end
    end
  end

  private
    def set_entities_list
      entities_list_id = params[:entities_list_id] || params[:id]
      @entities_list = @agent.entities_lists.friendly.find(entities_list_id)
    end

  private

    def entities_list_params
      params.require(:entities_list).permit(:listname, :description, :visibility)
    end

    def set_agent
      if params[:agent_id].present?
        @agent = Agent.friendly.find(params[:agent_id])
      else
        entities_list_id = params[:entities_list_id] || params[:id]
        @agent = EntitiesList.friendly.find(entities_list_id).agent
      end
    end

    def check_user_rights
      case action_name
        when 'new', 'create', 'edit', 'update'
          access_denied unless current_user.can? :edit, @agent
        else
          access_denied
      end
    end
end
