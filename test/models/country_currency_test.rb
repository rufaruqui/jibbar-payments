# == Schema Information
#
# Table name: country_currencies
#
#  id         :integer          not null, primary key
#  country    :string(255)
#  currency   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CountryCurrencyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
