class SendEmailsJob < ApplicationJob
  queue_as :default

  def perform(interview)
    # Do something later
    InterviewMailer.interview_scheduled(interview).deliver
  end
end
