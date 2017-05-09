# == Schema Information
#
# Table name: buy_credits
#
#  id               :integer          not null, primary key
#  code             :string(255)      not null
#  name             :string(255)      not null
#  description      :string(255)
#  credits          :integer          default("0"), not null
#  broadcasts       :integer
#  duration_in_days :integer
#  display          :boolean          default("1")
#  price            :decimal(10, 2)   default("0.00")
#  minimum_members  :integer
#  maximum_members  :integer
#  is_plan_for_team :boolean          default("0")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class BuyCredit < ApplicationRecord
end
