require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Admin::LogsHelper. For example:
#
# describe Admin::LogsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

module Admin
  module LogsHelper
    def format_log_date(timestamp)
      timestamp.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end

RSpec.describe Admin::LogsHelper, type: :helper do
  describe "format log date" do
    it "formats a timestamp into a readable string" do
      timestamp = Time.zone.parse("2020-01-01 12:00:00")
      expect(helper.format_log_date(timestamp)).to eq("2020-01-01 12:00:00")
    end
  end
end
