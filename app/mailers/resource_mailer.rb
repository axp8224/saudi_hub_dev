class ResourceMailer < ApplicationMailer
    default from: 'no-reply@example.com'
  
    def approval_notification(resource)
      @resource = resource
      @user = resource.author
      @feedback = resource.feedback.presence || "No feedback was given."
  
      mail(to: @user.email, subject: "Your Resource Submission Has Been Approved")
    end
  
    def rejection_notification(resource)
      @resource = resource
      @user = resource.user
      @feedback = resource.feedback.presence || "No feedback was given."
  
      mail(to: @user.email, subject: "Your Resource Submission Has Been Rejected")
    end
  end
  