# == Schema Information
#
# Table name: report_abuses
#
#  id           :integer          not null, primary key
#  email_id     :string
#  recipient_id :string
#  reason       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ReportAbuseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
