class UsersController < ApplicationController
    before_action:authenticate_user,{only:[:index,:show,:edit,:update]}
    before_action:forbid_login_user,{only:[:new,:create,:login_form,:login]}
    before_action:ensure_correct_user,{only:[:edit,:update]}

    def index
        @users = User.all
    end

    def show
        @user = User.find_by(id: params[:id])
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(name: params[:name],email: params[:email],image_name: "top.jpg",password: params[:pass])
        if @user.save
            session[:id] = @user.id
            session[:name] = @user.name
            flash[:notice]="ユーザー登録が完了しました"
            redirect_to("/users/#{@user.id}")
        else
            render("/users/new")
        end
    end

    def destroy
        @user = User.find_by(id: params[:id])
        @user.destroy
        flash[:notice] = "ユーザー登録を削除しました" 
        redirect_to("/users/index")
    end

    def edit
        @user = User.find_by(id: params[:id])
    end

    def update
        @user = User.find_by(id: params[:id])
        @user.name = params[:name]
        @user.email = params[:email]

        if params[:image]
            @user.image_name = "#{@user.id}.jpg"
            image = params[:image]
            File.binwrite("public/user_images/#{@user.image_name}",image.read)
        end

        if @user.save
          flash[:notice] = "ユーザー情報を編集しました"
          redirect_to("/users/#{@user.id}")
        else
          render("users/edit")
        end
    end

    def login_form
    end

    def login
        @user = User.find_by(
            email:params[:mail],
            password:params[:password]
        )
        if @user
            session[:id] = @user.id
            session[:name] = @user.name
            flash[:notice] = "ログインしました"
            redirect_to("/posts/index")
        else
            @error_message = "メールアドレスまたはパスワードが間違っています"
            @email = params[:mail]
            @password = params[:password]
            render("users/login_form")
        end
    end
    def logout
        session[:id] = nil
        flash[:notice] = "ログアウトしました"
        redirect_to("/login")
    end

    def ensure_correct_user
        if @current_user.id != params[:id].to_i
            flash[:notice]="権限がありません"
            redirect_to("/posts/index")
        end
    end
end
