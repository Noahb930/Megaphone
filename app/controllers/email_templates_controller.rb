class EmailTemplatesController < ApplicationController
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!
  # GET /templates
  # GET /templates.json
  def index
    @email_templates = EmailTemplate.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @email_template = EmailTemplate.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @email_template = EmailTemplate.new(email_template_params)
    respond_to do |format|
      if @email_template.save
        format.html { redirect_to email_templates_url, notice: 'Email Template was successfully created.' }
        # format.html { redirect_to @email_template, notice: 'template was successfully created.' }
        # format.json { render :show, status: :created, location: @email_template }
      else
        format.html { render :new }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @email_template.update(email_template_params)
        format.html { redirect_to email_templates_url, notice: 'Email Template was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @email_template.destroy
    respond_to do |format|
      format.html { redirect_to email_templates_url, notice: 'template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_template_params
      params.require(:email_template).permit(:subject, :body, :initiative_id, :name, representative_ids:[])
    end
end
