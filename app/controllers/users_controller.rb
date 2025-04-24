class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  
    # **過去7日分の投稿数**
    @past_week_counts = (0..6).map do |i|
      date = Time.zone.today - i.days
      label = case i
              when 0 then "今日"
              when 1 then "1日前"
              when 2 then "2日前"
              when 3 then "3日前"
              when 4 then "4日前"
              when 5 then "5日前"
              when 6 then "6日前"
              end
      count = @user.books.where(created_at: date.all_day).count || 0
      { date: label, count: count }
    end.reverse
  
    @chart_dates = @past_week_counts.map { |data| data[:date] }
    @chart_counts = @past_week_counts.map { |data| data[:count] }
  end
  
  
  



  

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
