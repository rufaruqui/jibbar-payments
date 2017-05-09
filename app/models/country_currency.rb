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

class CountryCurrency < ApplicationRecord
end
