Clarat Search Application
=========================

This is a JS application sitting inside the rails application. It handles the
user's search request, queries an eternal search service, and displays the
results.

It functions mostly independently from rails. Rails renders an almost empty
Offers#index page with a bit of supportive markup. The app then gets
instantiated and runs inside that prepared view.
