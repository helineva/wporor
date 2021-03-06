class BeerclubsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index]
  before_action :ensure_that_admin, only: :destroy
  before_action :set_beerclub, only: [:show, :edit, :update, :destroy]

  # GET /beerclubs
  # GET /beerclubs.json
  def index
    @beerclubs = Beerclub.all
    order = params[:order] || 'name'
    @beerclubs = case order
                 when 'name' then @beerclubs.sort_by(&:name)
                 when 'founded' then @beerclubs.sort_by(&:founded)
                 when 'city' then @beerclubs.sort_by(&:city)
                 end
  end

  # GET /beerclubs/1
  # GET /beerclubs/1.json
  def show
    @memberships = @beerclub.memberships
    @applications = @beerclub.applications
    @is_member = @memberships.map(&:user).include?(current_user)
    @is_applicant = @applications.map(&:user).include?(current_user)

    if @is_member || @is_applicant
      @membership = Membership.where(beerclub_id: @beerclub.id, user_id: current_user.id).first
      return
    end

    @membership = Membership.new
    @membership.user = current_user
    @membership.beerclub = @beerclub
  end

  # GET /beerclubs/new
  def new
    @beerclub = Beerclub.new
  end

  # GET /beerclubs/1/edit
  def edit
  end

  # POST /beerclubs
  # POST /beerclubs.json
  def create
    @beerclub = Beerclub.new(beerclub_params)

    respond_to do |format|
      if @beerclub.save
        Membership.create user_id: current_user.id, beerclub_id: @beerclub.id, confirmed: true

        format.html { redirect_to @beerclub, notice: 'Beerclub was successfully created.' }
        format.json { render :show, status: :created, location: @beerclub }
      else
        format.html { render :new }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beerclubs/1
  # PATCH/PUT /beerclubs/1.json
  def update
    respond_to do |format|
      if @beerclub.update(beerclub_params)
        format.html { redirect_to @beerclub, notice: 'Beerclub was successfully updated.' }
        format.json { render :show, status: :ok, location: @beerclub }
      else
        format.html { render :edit }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beerclubs/1
  # DELETE /beerclubs/1.json
  def destroy
    @beerclub.destroy
    respond_to do |format|
      format.html { redirect_to beerclubs_url, notice: 'Beerclub was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beerclub
    @beerclub = Beerclub.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def beerclub_params
    params.require(:beerclub).permit(:name, :founded, :city)
  end
end
