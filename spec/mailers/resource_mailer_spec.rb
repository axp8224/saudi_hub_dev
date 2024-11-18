require "rails_helper"

RSpec.describe ResourceMailer, type: :mailer do
  let(:user) { create(:user, full_name: "John Doe", email: "johndoe@example.com") }
  let(:resource) { create(:resource, title: "Sample Resource", feedback: "Great job!", author: user) }  

  describe 'approval_notification' do
    let(:mail) { ResourceMailer.approval_notification(resource) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Your Resource Submission Has Been Approved")
      expect(mail.to).to eq([resource.author.email])
      expect(mail.from).to eq(['no-reply@example.com'])
    end

    it 'renders the body without feedback' do
      expect(mail.body.encoded).to match("Dear John Doe,")
      expect(mail.body.encoded).to match("Your resource submission titled \"Sample Resource\" has been approved.")
      expect(mail.body.encoded).to match("Thank you for your contribution!")
      expect(mail.body.encoded).to match("Saudi Student Association")
    end
  end

  describe 'rejection_notification' do
    let(:mail) { ResourceMailer.rejection_notification(resource) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Your Resource Submission Has Been Rejected")
      expect(mail.to).to eq([resource.author.email])
      expect(mail.from).to eq(['no-reply@example.com'])
    end

    it 'renders the body without feedback' do
      expect(mail.body.encoded).to match("Dear John Doe,")
      expect(mail.body.encoded).to match("Unfortunately, your resource submission titled \"Sample Resource\" has been rejected.")
      expect(mail.body.encoded).to match("Saudi Student Association")
    end
  end

  describe 'feedback_update_notification' do
    let(:mail) { ResourceMailer.feedback_update_notification(resource) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Feedback Updated for Your Resource Submission")
      expect(mail.to).to eq([resource.author.email])
      expect(mail.from).to eq(['no-reply@example.com'])
    end

    it 'renders the body with feedback' do
      expect(mail.body.encoded).to match("Dear John Doe,")
      expect(mail.body.encoded).to match("Your resource submission, \"Sample Resource\", has received updated feedback:")
      expect(mail.body.encoded).to match("<blockquote>\n  Great job!\n</blockquote>")
      expect(mail.body.encoded).to match("Please review the feedback and make the necessary changes.")
      expect(mail.body.encoded).to match("Thank you!")
      expect(mail.body.encoded).to match("Saudi Student Association")
    end
  end
end
