class InterviewMailer < ApplicationMailer
    # default from: 'divya.donpati@gmail.com'

  def interview_scheduled
    @interview = params[:interview]
    logger.info "interview scheduled"
    # delivery_options = { user_name: params[:company].smtp_user,
    #     password: params[:company].smtp_password,
    #     address: params[:company].smtp_host }


    logger.info @interview
    logger.info Interviewee.find(@interview.interviewee_id).email
    
    mail(to: "divyadonpati@gmail.com", subject: "You got a new order!")
    # mail(:to => Interviewee.find(@interview.interviewee_id).email, :subject => "Interview Scheduled")
  end
end
