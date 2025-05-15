# Pagy initializer
require 'pagy/extras/array'
require 'pagy/extras/items'

# Set Pagy::DEFAULT options here:
Pagy::DEFAULT[:items] = 12        # items per page
Pagy::DEFAULT[:size]  = [1,4,4,1] # nav bar links 