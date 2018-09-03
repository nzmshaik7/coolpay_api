describe RecipientsController do
    describe '#authenticate_coolpay' do
	let (USERNAME) {'Naz1'}
	let (API_KEY)  {'6C5BC43B47397578'}
	it 'authenticate coolpay username and password' do 
	    post :authenticate_coolpay, params: {username: USERNAME, api_key: API_KEY}
	    expect(response.status).to eq 200
	end
    end

    describe '#index' do 
	it 'retrives a list of recipients from coolpay api' do
	    get :index
	    expect(assigns(:recipients).size).to eq 1
	    expect(response.status).to eq 200
	end
    end

    describe '#add_recipient' do
	it 'adds a new recipient' do
		post :add_recipient, params: {name: nameOne}
		expect(response).to redirect_to recipients_path
	end
    end

    describe '#make_payment' do
	context 'successful payment' do 
	    it 'adds a new payment' do 
		post :make_payment, params: {recipient_id: "123456-12345-12456", amount: 10, curreency: USD}
		expect(response).to redirect_to recipients_path
	    end
	end
	context 'failed payment' do 
	    it 'reports an error' do
		post :make_payment, params: {recipient_id: "123456-12345-12456", amount: 10, curreency: USD}
		expect(response).to raise_error(RestClient::UnprocessableEntity)
	    end
	end
    end

    describe '#verify_payemnt' do
	context 'payment reached to recipient' do
	    it 'credits money to recipient's account' do 
		post :verify_payment, params: {payment_id: "1234-2345-3456"}
		expect(response['status']).to should_be "paid" 
	    end
	end
	context 'payment didn't reach to recipient' do
	    it 'recipient didn't receive money' do 
		post :verify_payment, params: {payment_id: "1234-2345-3456"}
		expect(response['status']).to should_not_be "paid" 
	    end
	end

    end

    

    


    

end