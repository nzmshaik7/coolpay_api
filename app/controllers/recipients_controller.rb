
class CoolpayController < ApplicationController
    require 'rest-client'
    USERNAME = 'Naz1'
    API_KEY = '6C5BC43B47397578'
    BASE_URI = 'https://coolpay.herokuapp.com/api'
    before_action :authenticate_coolpay
    #before_action :authenticate_coolpay, :index; :only => [:add_payment]

#authentication
    def authenticate_coolpay
  	uri = BASE_URI + '/login'
	header = {"content-type" => "application/json"}
  	body = {"username": USERNAME,"apikey": API_KEY}.to_json
  	response = RestClient.post(uri, body, header)
	@token = JSON.parse(response)['token']	
    end
    
#Listing recipients   
    def index
	uri = BASE_URI + '/recipients'
  	body = {"username": USERNAME,"apikey": API_KEY}.to_json
  	header = {"content-type" => "application/json","authorization" => "Bearer #{@token}"}
  	response = RestClient.get(uri, header)
  	@recipients = JSON.parse(response)["recipients"]
    end

#Add a new recipient
    def new
    end
    def add_recipient
	uri = BASE_URI + '/recipients'
  	header = {"content-type" => "application/json","authorization" => "Bearer #{@token}"}
  	body = {"recipient": {"name": params[:recipient],}}.to_json
  	RestClient.post(uri, body, header)
	redirect_to recipients_path
    end

#create a payment
    def add_payment
	index
    end
    def make_payment
	uri = BASE_URI + '/payments'
	body = {"payment": {"amount": params[:amount],"currency": params[:currency],"recipient_id": params[:recipient]}}.to_json
	header = {"content-type" => "application/json","authorization" => "Bearer #{@token}"
  	}
	response = RestClient.post(uri, body, header)
	redirect_to recipients_path
	
    end

# Verify a payment
    def get_payments
	uri = BASE_URI + '/payments'
	header = {"content-type" => "application/json","authorization" => "Bearer #{@token}"}
	response = RestClient.get(uri, header)
	@payments = JSON.parse(response)["payments"]
    end

    def verify_payment
	get_payments
	check_payment = @payments.select {|payment| payment["id"] == params[:payment_id]}.first["status"]
	#check_payment["status"]
	respond_to do |format|
	    if (check_payment == "paid")
		format.html{redirect_to({action: 'index'}, notice: 'Payment Successful')}
	    else
		format.html{redirect_to({action: 'index'}, notice: 'Payment Failed')}
	    end
	end
		
    end

end