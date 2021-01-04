class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
    @initiative = Initiative.find(params[:initiative_id])
    respond_to do |format|
      format.js
    end
  end

  # GET /emails/1/edit
  def edit
    @email = Email.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)
    respond_to do |format|
      if @email.save
        params["representative_ids"].each do |representative_id|
          @recipiant = Recipiant.new(email_id:@email.id,representative_id:representative_id)
          @recipiant.save
        end
        format.html { render Initiative.find(email_params[:representative_id])}
        # format.html { redirect_to @email, notice: 'email was successfully created.' }
        # format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        @initiative=Initiative.find(@email.initiative_id)
        format.js {render :show}
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_params
      params.require(:email).permit(:subject, :body, :initiative_id)
    end
end
