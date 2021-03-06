class UsersController < ApplicationController

  # This method will assign a country to found
  # If not found then create a new country title
  # Assign country to a user
  def create
    found = Country.find_by(name: country_params[:country])
    if !found
      found = Country.create(name: country_params[:country])
    end
    found.users.create(user_params)

    render json: "user created", status: 200
  end

  # This method will check if the user has a country entry
  # If not, then assign a country to the user
  def update
    if country_params[:country]
      found = Country.find_by(name: country_params[:country])
      if !found
        found = Country.create(name: country_params[:country])
      end
      current_user.country_id = found.id
    end

    current_user.update(user_params)
    # This will update the hobbies of the user
    current_user.user_hobbies.delete_all
    [hobbies_params[:hobby1], hobbies_params[:hobby2], hobbies_params[:hobby3]].each do |hobby|
      current_user.user_hobbies.create(hobby_id: find_create_hobby(hobby))
    end
    render json: 'User has been updated', status: 200
  end

  # the show function will show the user and their 
  # hobbies, and country based on id
  def show_user
    @user = current_user
    @hobbies = current_user.hobbies
    @country = current_user.country
    render json: { user: @user, hobbies: @hobbies, country: @country }
  end

  private

  # Passing through the parameters of the user ie email, password, name, age
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :nickname, :age, :is_admin, :gender)
  end

    # Passing through the parameters of the hobbies of the user
  def hobbies_params
    params.require(:user).permit(:hobby1, :hobby2, :hobby3)
  end
  # Passing through the parameters of the country of the user
  def country_params
    params.require(:user).permit(:country)
  end

  # finds the hobbies and sets to lowercase
  def find_create_hobby(hobby)
    found = Hobby.find_by(name: hobby.downcase)
    if found
      return found.id
    else
      found = Hobby.create(name: hobby.downcase)
      return found.id
    end
  end
end
