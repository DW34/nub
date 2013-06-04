class PeopleController < ApplicationController
  before_filter :authenticate_person!

  def index
    authorize! :index, @person, :message => 'Not authorized as an administrator.'
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def update
    authorize! :update, @person, :message => 'Not authorized as an administrator.'
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person], :as => :admin)
      redirect_to people_path, :notice => "Person updated."
    else
      redirect_to people_path, :alert => "Unable to update person."
    end
  end

  def destroy
    authorize! :destroy, @person, :message => 'Not authorized as an administrator.'
    person = Person.find(params[:id])
    unless person == current_person
      person.destroy
      redirect_to people_path, :notice => "Person deleted."
    else
      redirect_to people_path, :notice => "Can't delete yourself."
    end
  end
end