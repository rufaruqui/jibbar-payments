# == Schema Information
#
# Table name: broadcasts
#
#  id                    :integer          not null, primary key
#  email_id              :string
#  emails_subject        :string
#  meta_data             :string
#  number_of_recipient   :integer
#  total_credit_consumed :integer
#  user_id               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Broadcast < ApplicationRecord
end
