class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new params.require(:membership).permit(:beerclub_id)
    @membership.user_id = current_user.id
    @membership.confirmed = false
    beerclub = Beerclub.find @membership.beerclub_id

    if @membership.save
      redirect_to current_user, notice: "You have applied for membership of #{beerclub.name}."
    else
      redirect_to current_user, notice: "Applying for membership of #{beerclub.name} failed."
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    beerclub_name = @membership.beerclub.name

    if @membership.confirmed
      notice = "Membership in #{beerclub_name} ended."
    else
      "Application for membership of #{beerclub_name} cancelled."
    end

    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: notice }
      format.json { head :no_content }
    end
  end

  def confirm
    membership = Membership.find(params[:id])
    beerclub = membership.beerclub
    if beerclub.memberships.map(&:user).include?(current_user)
      membership.update_attribute :confirmed, true
      redirect_to beerclub, notice: "User #{membership.user.username}'s membership confirmed."
    else
      redirect_back fallback_location: breweries_url, notice: 'You are not allowed to do that.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:beerclub_id, :user_id)
  end
end
