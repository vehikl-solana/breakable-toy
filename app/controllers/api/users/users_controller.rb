module Api
  module Users
    class UsersController < ApplicationController
      def index
        @users = User.all
        unless params[:query].blank?
          @users = @users.where("name LIKE ?", "%#{User.sanitize_sql_like(params[:query])}%")
                         .or(User.where("email LIKE ?", "%#{User.sanitize_sql_like(params[:query])}%"))
        end

        render json: @users
      end

      def show
        @user = User.find(params[:id])
        render json: @user
      end

      def create
        User.create!({
          :email => params[:email],
          :name => params[:name]
        })
      end

      def update
        user = User.find(params[:id])
        user.update!({
          :name => params[:name],
          :email => params[:email],
        })
      end

      def destroy
        delete_count = User.delete(params[:id])
        raise ActiveRecord::RecordNotFound if delete_count == 0
      end
    end
  end
end

