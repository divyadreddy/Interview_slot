class InterviewsController < ApplicationController
  before_action :set_interview, only: [:show, :edit, :update, :destroy]

  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = Interview.all.order(:start_time)
  end

  # GET /interviews/1
  # GET /interviews/1.json
  def show
  end

  # GET /interviews/new
  def new
    @interview = Interview.new
  end

  # GET /interviews/1/edit
  def edit
  end

  # POST /interviews
  # POST /interviews.json
  def create
    result = participants_available
    @interview = Interview.new(interview_params)
    if(result == 0)
      respond_to do |format|
        if @interview.save
          format.html { redirect_to @interview, notice: 'Interview was successfully created.' }
          format.json { render :show, status: :created, location: @interview }
        else
          format.html { render :new }
          format.json { render json: @interview.errors, status: :unprocessable_entity }
        end
      end
    elsif result==1 
      # @errors = ActiveModel::Errors.new(self)
      respond_to do |format|
        @interview.errors.add(params[:interview][:interviewer_id], message: "Interviewer is not available in this time slot") 
        format.html {  render :new }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    elsif result==2
      # @errors = ActiveModel::Errors.new(self)
      respond_to do |format|
        @interview.errors.add(params[:interview][:interviewee_id], message: "Interviewee with ID ? is not available in this time slot")
        format.html {  render :new }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interviews/1
  # PATCH/PUT /interviews/1.json
  def update
    respond_to do |format|
      if @interview.update(interview_params)
        format.html { redirect_to @interview, notice: 'Interview was successfully updated.' }
        format.json { render :show, status: :ok, location: @interview }
      else
        format.html { render :edit }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interviews/1
  # DELETE /interviews/1.json
  def destroy
    @interview.destroy
    respond_to do |format|
      format.html { redirect_to interviews_url, notice: 'Interview was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interview
      @interview = Interview.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interview_params
      params.require(:interview).permit(:title, :start_time, :end_time, :interviewer_id, :interviewee_id) 
    end

    def participants_available
      logger.info((params[:interview]["title"]))
      start = DateTime.new(params[:interview]["start_time(1i)"].to_i, 
      params[:interview]["start_time(2i)"].to_i,
      params[:interview]["start_time(3i)"].to_i,
      params[:interview]["start_time(4i)"].to_i,
      params[:interview]["start_time(5i)"].to_i)
      close = DateTime.new(params[:interview]["end_time(1i)"].to_i, 
      params[:interview]["end_time(2i)"].to_i,
      params[:interview]["end_time(3i)"].to_i,
      params[:interview]["end_time(4i)"].to_i,
      params[:interview]["end_time(5i)"].to_i)
      # logger.info("here" + params[:interview][:interviewer_id] + params[:interview]["start_time(1i)"])#.strftime('%a %b %d %H:%M:%S %Z %Y') )# + params[:interview][:end_time])
      time_clash = Interview.where("(end_time BETWEEN ? AND ?) or (start_time BETWEEN ? AND ?) or ((end_time > ?) and (start_time < ?))", start, close, start, close, close, start)
      if time_clash.where("interviewer_id = ?", params[:interview][:interviewer_id]).exists?
        return 1
      end
      if time_clash.where("interviewee_id = ?", params[:interview][:interviewee_id]).exists?
        return 2
      end
      return 0
    end
end
