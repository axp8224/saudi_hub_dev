require "rails_helper"

RSpec.describe ResourceMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:resource) { create(:resource, feedback: "Great job!", author: user) }  

  describe 'approval_notification' do
    let(:mail) { ResourceMailer.approval_notification(resource) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Your Resource Submission Has Been Approved")
      expect(mail.to).to eq([resource.author.email]) 
      expect(mail.from).to eq(['no-reply@example.com'])
    end

    it 'renders the body with feedback' do
      expect(mail.body.encoded).to match("Great job!")
    end
  end

  describe 'rejection_notification' do
    let(:mail) { ResourceMailer.rejection_notification(resource) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Your Resource Submission Has Been Rejected")
      expect(mail.to).to eq([resource.author.email])  
      expect(mail.from).to eq(['no-reply@example.com'])
    end

    it 'renders the body with feedback' do
      expect(mail.body.encoded).to match("Great job!")
    end
  end
end


