class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
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
    

    if @booking.valid?
      if !@booking.pmd?
      purchase_call = complete_purchase(booking_params[:amount], booking_params[:payment_token], booking_params[:save_credit_card])



      if purchase_call['transaction']['succeeded']==true
        if @booking.save
         redirect_to bookings_path, notice: "Booking was successfully updated." 
   
        else
          redirect_to flight_path, notice: "Payment not saved, email tech support" 
        
        end
      else
        redirect_to new_booking_path + '?flight_id='+booking_params[:flight_id], notice: "Payment method declined" 

      end
      
      else

      receiver = use_receiver(booking_params[:amount], booking_params[:payment_token])
      puts receiver['transaction']['succeeded']

      if receiver['transaction']['succeeded'] ==true
        @booking.save
        redirect_to bookings_path, notice: "Booking with Receiver was successful." 
      else
        redirect_to new_booking_path + '?flight_id='+booking_params[:flight_id], notice: "Receiver Payment method declined" 
      end


    end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def use_receiver(amount, token)
      uri = 'https://core.spreedly.com/v1/receivers/' + ENV['RECEIVER_TOKEN'] + '/deliver.json'

   
      
      response = Faraday.post(uri) do |req |
      encoded = Base64.strict_encode64("#{ENV['ACCESS_KEY']}:#{ENV['ACCESS_SECRET']}")
      req.headers['Authorization'] = "Basic #{encoded}"
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "delivery": {
          "payment_method_token": token,
          "url": "https://spreedly-echo.herokuapp.com",
           "body": "{ \"amount\": #{amount},\"card_number\": \"{{credit_card_number}}\" }"
        }
      }.to_json
    end

       return JSON.parse(response.body)

    end

     def complete_purchase(amount, token, save_credit_card)
    uri = 'https://core.spreedly.com/v1/gateways/' + ENV['GATEWAY_TOKEN'] + '/purchase.json'

    response = Faraday.post(uri) do |req |
        encoded = Base64.strict_encode64("#{ENV['ACCESS_KEY']}:#{ENV['ACCESS_SECRET']}")
    req.headers['Authorization'] = "Basic #{encoded}"
    req.headers['Content-Type'] = 'application/json'
    req.body = {
      "transaction": {
        "payment_method_token": token,
        "amount": amount,
        "currency_code": "USD",
        "retain_on_success": save_credit_card
      }
    }.to_json

    end
    return JSON.parse(response.body)

end


    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:flight_id, :amount, :payment_token, :save_credit_card, :pmd, :email)
    end
end
