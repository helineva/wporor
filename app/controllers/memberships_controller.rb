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
    id = current_user.id
    beerclubs_already_member = Beerclub.joins(:memberships).where(memberships: { user_id: id }).select(:id).distinct
    @beerclubs = Beerclub.where.not(id: beerclubs_already_member)
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new params.require(:membership).permit(:beerclub_id)
    @membership.user_id = current_user.id

    if @membership.save
      redirect_to @membership.beerclub, notice: "#{@membership.user.username} welcome to the club!"
    else
      @beerclubs = Beerclub.all
      render :new
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
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Membership in #{beerclub_name} ended." }
      format.json { head :no_content }
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
