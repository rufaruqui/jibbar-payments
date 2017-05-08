# == Schema Information
#
# Table name: emails
#
#  id             :integer          not null, primary key
#  template_id    :string
#  user           :string
#  subject        :string
#  body           :text
#  state          :integer          default("0")
#  public_id      :string
#  from_name      :string
#  from_address   :string
#  reply_address  :string
#  scheduled_on   :datetime
#  sent_on        :datetime
#  recipients     :jsonb            default("[]"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  template_count :integer          default("0")
#  links          :jsonb
#

require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
