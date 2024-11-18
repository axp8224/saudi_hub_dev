class ResourceMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  # Notify the user when the resource is approved
  def approval_notification(resource)
    @resource = resource
    @user = resource.author

    mail(to: @user.email, subject: "Your Resource Submission Has Been Approved")
  end

  # Notify the user when the resource is rejected
  def rejection_notification(resource)
    @resource = resource
    @user = resource.author

    mail(to: @user.email, subject: "Your Resource Submission Has Been Rejected")
  end

  # Notify the user when feedback is updated
  def feedback_update_notification(resource)
    @resource = resource
    @user = resource.author
    @feedback = resource.feedback

    mail(to: @user.email, subject: "Feedback Updated for Your Resource Submission")
  end
end
