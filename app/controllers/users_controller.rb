class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    # 今日と昨日の投稿数
    @today_book = @user.books.where(created_at: Time.zone.today.all_day)
    @yesterday_book = @user.books.where(created_at: Time.zone.yesterday.all_day)

    @today_count = @today_book.count
    @yesterday_count = @yesterday_book.count
    @the_day_before = @yesterday_count > 0 ? (@today_count.to_f / @yesterday_count.to_f * 100).round : nil

    # 今週と前週の投稿数
    start_of_week = Time.zone.today.beginning_of_week(:saturday)
    end_of_week = Time.zone.today.end_of_week(:friday)
    start_of_last_week = start_of_week - 7.days
    end_of_last_week = end_of_week - 7.days

    @this_week_book = @user.books.where(created_at: start_of_week..end_of_week)
    @last_week_book = @user.books.where(created_at: start_of_last_week..end_of_last_week)

    @this_week_count = @this_week_book.count
    @last_week_count = @last_week_book.count
    @the_week_before = @last_week_count > 0 ? (@this_week_count.to_f / @last_week_count.to_f * 100).round : nil
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
