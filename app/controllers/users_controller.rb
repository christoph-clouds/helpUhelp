class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @roles = Role.all
  end

  # GET /users/1/edit
  def edit
    @roles = Role.all
  end

  # POST /users
  # POST /users.json
  def create
    @roles = Role.all
    random_password = Randomstring.generate(20)
    p = user_params
    p[:password] = random_password;
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # Deliver the signup email
        ApplicationMailer.send_signup_email(@user).deliver_now
        format.html { redirect_to @user, notice: 'Benutzer wurde angelegt.' }
        format.json { render :show, status: :created, location: @user }

      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    def check_password(user)
      if user[:password] == user[:password_confirmation]
        return true
      else
        return false
      end
    end
    respond_to do |format|
      if check_password(user_params) && @user.update(user_params)
        format.html { redirect_to @user, notice: 'Benutzerdaten wurden aktualisiert.' }
        format.json { render :show, status: :ok, location: @user }
      else
        if check_password(user_params)
          format.html { 
            @alert = "test"
            render :edit
          }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        else
          format.html { 
            @alert = 'Das Passwort muss mit der Bestätigung übereinstimmen!'
            render :edit 
          }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    task_ids = StatusTaskUser.where(user_id: @user.id).where(status_id: 3).pluck(:task_id)
    relevant = Task.where(id: task_ids).where("date >= ?", Date.today)
    if(!relevant.empty?()) 
      respond_to do |format|
        format.html { redirect_to users_url, alert: 'Benutzer kann nicht gelöscht werden, wenn ihm noch Aufgaben zugewiesen sind!' }
        format.json { head :no_content }
      end
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'Benutzer wurde gelöscht.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:role_id, :first_name, :last_name, :email, :telephone, :password, :password_confirmation)
    end
end
