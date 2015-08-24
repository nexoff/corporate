class Web::ProjectsController < Web::ApplicationController
  add_breadcrumb {{ url: projects_path }}

  def index
    skip_policy_scope
    authorize :project
    @q = policy_scope(Project).search(params[:q])
    @q.sorts = 'id desc' if @q.sorts.empty?
    @projects = @q.result.page(params[:page])
    respond_with @projects
  end

  def show
    @project = Project.find params[:id]
    authorize @project
    add_breadcrumb model: @project
    @tasks_with_cost = TasksCostQuery.perform(@project)
    @total_expenses = @tasks_with_cost.sum{ |task_cost| task_cost[:cost] }
    respond_with @project
  end

  def new
    @project = Project.new
    authorize @project
    add_breadcrumb
    respond_with @project
  end

  def create
    @project = Project.new
    authorize @project
    add_breadcrumb
    @project.update project_params
    respond_with @project
  end

  def edit
    @project = Project.find params[:id]
    authorize @project
    add_breadcrumb model: @project
    respond_with @project
  end

  def update
    @project = Project.find params[:id]
    authorize @project
    add_breadcrumb model: @project
    @project.update project_params
    respond_with @project
  end

  private

  def project_params
    attrs = policy(@project).permitted_attributes
    params.require(:project).permit(attrs)
  end
end
