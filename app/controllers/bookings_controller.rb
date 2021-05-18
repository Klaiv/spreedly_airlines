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
      purchase_call = complete_purchase(booking_params[:amount], booking_params[:payment_token], booking_params[:save_credit_card])
      if purchase_call['transaction']['succeeded']==false
        if @booking.save
         redirect_to bookings_path, notice: "Booking was successfully updated." 
   
        else
          redirect_to flight_path, notice: "Payment not saved, email tech support" 
        
        end
      else
        redirect_to new_booking_path + '?flight_id='+booking_params[:flight_id], notice: "Payment method declined" 

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

     def complete_purchase(amount, token, save_credit_card)
    uri = 'https://core.spreedly.com/v1/gateways/' + ENV['GATEWAY_TOKEN'] + '/purchase.json'

    # response = Faraday.post(uri) do |req |
    #     encoded = Base64.strict_encode64("#{ENV['ACCESS_KEY']}:#{ENV['ACCESS_SECRET']}")
    # req.headers['Authorization'] = "Basic #{encoded}"
    # req.headers['Content-Type'] = 'application/json'
    # req.body = {
    #   "transaction": {
    #     "payment_method_token": token,
    #     "amount": amount,
    #     "currency_code": "USD",
    #     "retain_on_success": save_credit_card
    #   }
    # }.to_json

    # end
    null = "0"
    response = {
    "transaction": {
        "on_test_gateway": true,
        "created_at": "2021-05-18T03:56:27Z",
        "updated_at": "2021-05-18T03:56:27Z",
        "succeeded": true,
        "state": "succeeded",
        "token": "UVgt2wn2s2VBQfS4bSVbYVnp9jQ",
        "transaction_type": "Purchase",
        "order_id": null,
        "ip": null,
        "description": null,
        "email": null,
        "merchant_name_descriptor": null,
        "merchant_location_descriptor": null,
        "merchant_profile_key": null,
        "gateway_specific_fields": null,
        "gateway_specific_response_fields": {},
        "gateway_transaction_id": "66",
        "gateway_latency_ms": 0,
        "stored_credential_initiator": null,
        "stored_credential_reason_type": null,
        "warning": null,
        "application_id": null,
        "amount": 312,
        "currency_code": "USD",
        "retain_on_success": false,
        "payment_method_added": false,
        "smart_routed": false,
        "message_key": "messages.transaction_succeeded",
        "message": "Succeeded!",
        "gateway_token": "BJNbUD339XcZgfBj3yJKQEQnYZM",
        "gateway_type": "test",
        "response": {
            "success": true,
            "message": "Successful purchase",
            "avs_code": null,
            "avs_message": null,
            "cvv_code": null,
            "cvv_message": null,
            "pending": false,
            "result_unknown": false,
            "error_code": null,
            "error_detail": null,
            "cancelled": false,
            "fraud_review": null,
            "created_at": "2021-05-18T03:56:27Z",
            "updated_at": "2021-05-18T03:56:27Z"
        },
        "shipping_address": {
            "name": "First Last",
            "address1": null,
            "address2": null,
            "city": null,
            "state": null,
            "zip": null,
            "country": null,
            "phone_number": null
        },
        "api_urls": [
            {
                "referencing_transaction": []
            },
            {
                "failover_transaction": []
            }
        ],
        "attempt_3dsecure": false,
        "payment_method": {
            "token": "XeVyBkc1QRua51Dl1tLXYiXtQjE",
            "created_at": "2021-05-17T20:48:36Z",
            "updated_at": "2021-05-17T20:48:36Z",
            "email": "be@c.com",
            "data": null,
            "storage_state": "cached",
            "test": true,
            "metadata": null,
            "callback_url": null,
            "last_four_digits": "1111",
            "first_six_digits": "411111",
            "card_type": "visa",
            "first_name": "First",
            "last_name": "Last",
            "month": 12,
            "year": 2024,
            "address1": null,
            "address2": null,
            "city": null,
            "state": null,
            "zip": null,
            "country": null,
            "phone_number": null,
            "company": null,
            "full_name": "First Last",
            "eligible_for_card_updater": true,
            "shipping_address1": null,
            "shipping_address2": null,
            "shipping_city": null,
            "shipping_state": null,
            "shipping_zip": null,
            "shipping_country": null,
            "shipping_phone_number": null,
            "payment_method_type": "credit_card",
            "errors": [],
            "fingerprint": "e3cef43464fc832f6e04f187df25af497994",
            "verification_value": "",
            "number": "XXXX-XXXX-XXXX-1111"
        }
    }
}
    return JSON.parse(response.to_json)

end


    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:flight_id, :amount, :payment_token, :save_credit_card, :pmd, :email)
    end
end
