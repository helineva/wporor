class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.non_github_users.find_by username: params[:username]
    if user&.authenticate(params[:password])
      if user.disabled
        redirect_to signin_path, notice: "your account is closed, please contact admin"
      else
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      end
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def create_oauth
    authhash = request.env['omniauth.auth']
    nickname = authhash.info.nickname
    user = User.github_users.find_by username: nickname
    return redirect_to signin_path, notice: "your account is closed, please contact admin" if user&.disabled

    if !user
      pw = generate_random_password
      user = User.create username: nickname, password: pw, password_confirmation: pw, github: true
    end
    session[:user_id] = user.id
    redirect_to user_path(user), notice: "Welcome back!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  private

  def generate_random_password
    ((5..rand(10..15)).map{ rand(10..36) }.map{ |n| n.to_s(36) } \
      + (5..rand(10..15)).map{ rand(10..36) }.map{ |n| n.to_s(36) }.map(&:upcase) \
      + rand(10_000..10_000_000_000).to_s.chars).shuffle.join
  end
end
