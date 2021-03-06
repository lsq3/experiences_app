class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @event_type_filter = params[:event_type_filter]

    is_filtered = !params[:event_time_filter].blank? || !params[:event_date_filter].blank? || !params[:event_type_filter].blank?


    @events = is_filtered ? Event.filtered(params[:event_time_filter], params[:event_date_filter], params[:event_type_filter]) : Event.all

    @categories = Category.all

  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find params[:id]
    @post = Post.new(event_id: @event.id)
    @event_users = EventsUser.where(event_id: params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @events = Event.find params[:id]
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.category = Category.find_by(name: params[:category_name])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    e = Event.new
    e.cover_img = params[:file]
      puts "-------"
      puts params[:file]


    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
    session[:event_id] = @event[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:id, :event_date_filter, :name, :description, :cover_img, :start_date, :time, :creator_id, :lng, :lat, :remote_cover_img_url, :category_name)
  end
end
