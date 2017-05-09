# == Schema Information
#
# Table name: plans
#
#  id                :integer          not null, primary key
#  code              :string(255)      not null
#  name              :string(255)      not null
#  description       :string(255)
#  credits           :integer          default("0"), not null
#  broadcasts        :integer
#  duration_in_days  :integer
#  display           :boolean          default("1")
#  price             :decimal(10, 2)   default("0.00")
#  minimum_members   :integer
#  maximum_members   :integer
#  stripe_id         :string(255)
#  is_plan_for_team  :boolean          default("0")
#  is_auto_renewable :boolean          default("1")
#  interval          :string(255)
#  interval_count    :integer          default("1"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
