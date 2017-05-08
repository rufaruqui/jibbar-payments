class EmailSerializer < ActiveModel::Serializer
  attributes :public_id, :subject, :body, :state
end
