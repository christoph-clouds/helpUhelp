class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :add_user, :remove_user]
  before_action :require_login

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    @all_statustaskuser_entries = StatusTaskUser.all

    @assigned_usertasks = Task.find(@all_statustaskuser_entries.where("user_id = ? and status_id = 3", current_user.id).pluck(:task_id))

    @pending_usertasks= Task.find(@all_statustaskuser_entries.where("user_id = ? and status_id = 1", current_user.id).pluck(:task_id))


    @open_usertasks = Task.all

    @unassigned_tasks = @tasks
    # -> wird assigned umgespeichert??? -> soll m
    @assigned_tasks = Task.find(@all_statustaskuser_entries.where("status_id = 2").pluck(:task_id))

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
  end

  # add user to task
  def add_user
    @stu = StatusTaskUser.new({:user_id => current_user.id, :task_id => @task.id, :status_id => 1})
    respond_to do |format|
      if @stu.save
        format.html { redirect_to tasks_url, notice: 'Für die Aufgabe beworben!' }
        format.json { head :no_content }
      else
        format.html { redirect_to tasks_url, notice: 'Nix Passiert!' }
        format.json { head :no_content }
      end
    end
  end

  # remove user from task
  def remove_user
    @task.users.delete(@current_user)
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Bewerbung für Aufgabe abgesagt!' }
      format.json { head :no_content }
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:description, :date, :time, :place, :assigned, :no_of_people, :title)
    end
end
