class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
    @transactions = all_transactions['transactions']
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @selected_flight = Flight.find(params[:flight_id])
    @booking = Booking.new
  
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings or /bookings.json
  def create

  @booking = Booking.new(booking_params)
  if @booking.pmd?
    success_notice="Expedia received your information was successfully"
    response = use_receiver(booking_params[:amount], booking_params[:payment_token])
  else
    success_notice="Booking with Spreedly Airlines was successful"
    response= complete_purchase(booking_params[:amount], booking_params[:payment_token], booking_params[:save_credit_card])
  end

     if response['transaction']['succeeded']==true

         if @booking.save
         redirect_to bookings_path, notice: success_notice 
   
        else
          redirect_to flights_path, notice: "Payment was successful but booking not saved, email tech support" 
        
        end


     else
      if response['transaction']['message'] !=""
          notice_message = response['transaction']['message']
        else
          notice_message ="Payment method declined"
        end
        redirect_to new_booking_path + '?flight_id='+booking_params[:flight_id], notice:  notice_message 

     end

    

   
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: "Booking was successfully updated." }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "Booking was successfully destroyed." }
      format.json { head :no_content }
    end
  end
    

  private

    BASE_URI = 'https://core.spreedly.com/v1/'
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def stored_cards
        uri = 'https://core.spreedly.com/v1/payment_methods.json'
        return get_call(uri)
       
    end

    def all_transactions
       uri = 'https://core.spreedly.com/v1/transactions.json?state=succeeded&order=desc'

      return get_call(uri)
    end

    def get_call(uri)
      response = Faraday.get(uri) do |req |
                  encoded = Base64.strict_encode64("#{ENV['ACCESS_KEY']}:#{ENV['ACCESS_SECRET']}")
                req.headers['Authorization'] = "Basic #{encoded}"
                req.headers['Content-Type'] = 'application/json'
    

              end
        return JSON.parse(response.body)

    end

       def complete_purchase(amount, token, save_credit_card)
      

        body ={
             "transaction":{
                "payment_method_token": token,
                "amount": amount,
                "currency_code": "USD",
                "retain_on_success": save_credit_card
             }
          }.to_json

        return make_call("gateways",ENV['GATEWAY_TOKEN'], "purchase.json" , body)
    end

    def use_receiver(amount, token)
          

          body =  {
             "delivery":{
                "payment_method_token": token,
                "url": "https://spreedly-echo.herokuapp.com",
                "body": "{ \"amount\": #{amount},\"card_number\": \"{{credit_card_number}}\" }"
             }
          }.to_json
      return make_call("receivers",ENV['RECEIVER_TOKEN'], "deliver.json" , body)
  

      end

    def make_call(type, path_token, endpoint, body)
      uri = BASE_URI + type + '/' + path_token + '/' + endpoint 

      response = Faraday.post(uri) do |req |
                  encoded = Base64.strict_encode64("#{ENV['ACCESS_KEY']}:#{ENV['ACCESS_SECRET']}")
                req.headers['Authorization'] = "Basic #{encoded}"
                req.headers['Content-Type'] = 'application/json'
                req.body = body

              end
        return JSON.parse(response.body)
    end


    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:flight_id, :amount, :payment_token, :save_credit_card, :pmd, :email)
    end
end
