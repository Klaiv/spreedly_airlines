# Getting familiar with Spreedly Express and API, 
---

# Getting Started



### Install and Run Project , IT AINT MUCH BUT IT WORKS :)
```
git clone <repo>
cd <repo>
bundle install

config your env keys in config/example_dev_env.yml and change to dev.env.yml

rails db:migrate && rails db:seed

rails s

```


### Usage

Access site at `localhost:3000` to view and book seed flights flights
`localhost:3000/bookings` to view bookings made on the site(local storage) and transactions from Spreedly API



---
**Notes**
----
* Focused on minimal functionality and design for the app - could have done more in improving the site but felt this was an exercise to familiarize myself with spreedly api and not make an awesome booking system.
* It was a good and quick ruby/rails refresher
* Accessing and using the Spreedly API and adding Express to the app was straightforward
* I wish it was possible to specify the type of transactions to get calling `/v1/transactions.<format>`
* While testing, there seemed to be a delay between adding a payment method and retrieving it via `/v1/payment_method.<format>`. The transaction would show up in the dashboard but not be returned by an api call.
* Noticed that while in dashboard, the session never times out for me on closing/opening browser


## Testing

No tests implemented in this app, 





