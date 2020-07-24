class WishesController < ApplicationController
    before_action :authenticate_user
    before_action :find_wish, only: [:show, :update, :destroy, :update_image]

    def index
      wishes = Wish.all.with_attached_image
      render json: {wishes: generate_image_url(wishes)}
    end

    def show
      render json: {wishes: generate_image_url([@wish])}
    end

    def create
      wish = current_user.wishes.new(wish_params)
        if wish.save
          if wish_params[:image]
            render json: {wish: wish, image: url_for(wish.image)}, status: :created
          else
            render json:{wish: wish, image: ''}, status: :created
          end
        else
            render json: {errors: wish.errors.full_messages}, status: :unprocessable_entity 
        end
    end

    def update
        if @wish.update(wish_params)
            render json: {}, status: :no_content
        else 
            render json: {errors: @wish.errors.full_messages}, status: :unprocessable_entity
        end
    end

    def update_image
      @wish.image.purge
      @wish.image.attach(wish_params[:image])
      render json: url_for(@wish.image)
    end

    def destroy
        @wish = Wish.find(params[:id])
        @wish.destroy
        render json: {}, status: :no_content
    end

private

    def wish_params
        params.require(:wish).permit(:title, :description, :is_secret, :is_anonymous, :is_completed, :is_matched, :like, :expiry_time, :user_id, :image)
    end

    def find_wish 
        @wish = Wish.find(params[:id])
    end

    def generate_image_url(wishes)
      wishes.map do |wish|
        if wish.image.attached?
          wish.attributes.merge(image: url_for(wish.image),user: wish.user.first_name, keywords: wish.keywords)
        else
          wish.attributes.merge(user:wish.user.first_name, keywords:wish.keywords)
        end
      end      
    end
end