class ConnectorsController < ApplicationController
  before_action :set_connector, only: [:show, :edit, :update, :destroy]
  before_action :set_numbers_and_channels, except: [:show, :index, :inbound]
  before_filter :authenticate, except: ['inbound']
  protect_from_forgery :except => :inbound

  # GET /connectors
  # GET /connectors.json
  def index
    @connectors = Connector.all
  end

  # GET /connectors/1
  # GET /connectors/1.json
  def show
  end

  # GET /connectors/new
  def new
    @connector = Connector.new
  end

  # GET /connectors/1/edit
  def edit
  end

  # POST /connectors
  # POST /connectors.json
  def create
    @connector = Connector.new(connector_params)

    respond_to do |format|
      if @connector.save
        format.html { redirect_to @connector, notice: 'Connector was successfully created.' }
        format.json { render :show, status: :created, location: @connector }
      else
        format.html { render :new }
        format.json { render json: @connector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connectors/1
  # PATCH/PUT /connectors/1.json
  def update
    respond_to do |format|
      if @connector.update(connector_params)
        format.html { redirect_to @connector, notice: 'Connector was successfully updated.' }
        format.json { render :show, status: :ok, location: @connector }
      else
        format.html { render :edit }
        format.json { render json: @connector.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connectors/1
  # DELETE /connectors/1.json
  def destroy
    @connector.destroy
    respond_to do |format|
      format.html { redirect_to connectors_url, notice: 'Connector was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /inbound
  def inbound
    Log.create(title: "Inbound message received.", raw_data: params.to_json)
    @connector = Connector.where()
    @connector.update(user_number: )
    #Post to slack channel message from params['from']: params[message]. (attachedment)
    #updated user_number
    #add thing that makes announcement in model-level callback
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connector
      @connector = Connector.find(params[:id])
    end

    def set_numbers_and_channels
      client = Slack::Web::Client.new
      @channels = client.channels_list['channels'].select {|channel| channel['is_member'] }.map {|channel| [channel['name'], channel['id']] }
      @numbers = TwilioClient.incoming_phone_numbers.list().map { |number| number.phone_number }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def connector_params
      params.require(:connector).permit(:channel, :mug_number, :user_number)
    end
end
