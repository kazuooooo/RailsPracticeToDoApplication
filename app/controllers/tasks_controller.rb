class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  # GET /tasks
  # GET /tasks.json
  def index
    @task = Task.new
    @tasks = current_user.tasks.all
    @user = current_user
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @user = current_user
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.build(task_params)
    respond_to do |format|
      if @task.save
        format.html { render nothing: true, status: :created }
      else
        format.html { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.json { render :json => @task,location: @task}
      else
        format.json { render json: @task.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { render nothing: true, status: :ok}
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:status,:title, :content, :plan_date, :actual_date)
    end

    def edit_page?
      return /\/tasks\/[0-9]*\/edit/ === request.env["PATH_INFO"]
    end
end
