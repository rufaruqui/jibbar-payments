if Rails.env.development?
    ENV['BUNNY_CONNECTION'] = "amqp://qkhffgzd:SU5MeIO0ni9Vl2F_qRCVOdlV7fezu8Dw@blond-lynx.rmq.cloudamqp.com/qkhffgzd"
    ENV['BUNNY_GET_USER_BY_TOKEN_QUEUE'] = "rpc_user_token"
    ENV['BUNNY_GET_TOKEN_RESPONSE_QUEUE'] = "rpc_user_token_response"
    ENV['BUNNY_SEND_TRANSACTIONAL_MAIL_QUEUE'] = "send_transactional_mail"
    ENV['BUNNY_USER_SUBSCRIPTION_ROLE_QUEUE'] = "user_subscription_role"
    ENV['STRIPE_PUBLISHABLE_KEY'] = "pk_test_CEx5IZkkxnTlwk4REHh41osm"
    ENV['STRIPE_SECRET_KEY'] = "sk_test_2L73QIh6fklUoIvfLCZ315HZ"
end