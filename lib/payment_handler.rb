# Perform the CC transaction (raises exception if not successful)
#
# NOTE: your server must be accessible from the internet in order for this to work,
#       and when in production mode, the server port must be 80 or 443  (can't run production mode with localhost:3000)
module PaymentHandler
	class Billing

    def initialize api_login_id, transaction_key, gateway
      @api_login_id = api_login_id
      @transaction_key = transaction_key
      @gateway = gateway.to_sym
		end

    def make_payment(order)
			
      transaction = AuthorizeNet::AIM::Transaction.new( @api_login_id, @transaction_key,{:gateway => @gateway})
      raise transaction.inspect
      transaction.set_fields(:email_address => order.email)
      transaction.set_fields(:first_name => order.first_name)
      transaction.set_fields(:last_name => order.last_name)
      transaction.set_fields(:ship_to_first_name => order.first_name)
      transaction.set_fields(:ship_to_last_name => order.last_name)
      transaction.set_fields(:ship_to_address => order.address)
      transaction.set_fields(:ship_to_city => order.city)
      transaction.set_fields(:ship_to_state => order.state)
      transaction.set_fields(:ship_to_zip_code => order.zip)
      transaction.set_fields(:address => order.billing_address)
      transaction.set_fields(:city => order.billing_city)
      transaction.set_fields(:state => order.billing_state)
      transaction.set_fields(:zip_code => order.billing_zip)
      transaction.set_fields(:tax => order.tax_amount)
      transaction.set_fields(:exp_date => order.exp_date)
      
      # order.ccv_number is not used ???!!
      
      # for testing use CC number '4111111111111111', and card date (MMYY) '1144'
      credit_card = AuthorizeNet::CreditCard.new(order.credit_card_number, order.exp_date)
      response = transaction.purchase(order.total_amount, credit_card)
      raise response.response_reason_text.to_s if response.success? ==false
      response
    end
	end
end

# example failure
#<AuthorizeNet::AIM::Transaction:0xb08d74c @fields={}, @custom_fields={}, @test_mode=false, @version="3.1", @api_login_id="5m7Y75eF9N", @api_transaction_key="5Vdd57sE9ncd56TE", @response=nil, @delimiter=",", @type="AUTH_CAPTURE", @cp_version=nil, @gateway="https://test.authorize.net/gateway/transact.dll", @allow_split_transaction=false, @encapsulation_character=nil, @verify_ssl=false, @market_type=2, @device_type=1>