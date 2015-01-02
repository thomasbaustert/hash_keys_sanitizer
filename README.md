# hash_keys_sanitizer

Sanitizes a hash keys according to a whitelist.

## Installation

Add this line to your application's Gemfile:

    gem 'hash_keys_sanitizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_keys_sanitizer

## Usage

`HashKeysSanitizer` is initialized with a whitelist as array, for example: 

    HashKeysSanitizer.new(whitelist: [:name, :email:, :age])
    HashKeysSanitizer.new(whitelist: [:name, address: [:street, :city, email: [:type]]])

To sanitizes the hash call `sanitize` passing the hash:

    sanitizer = HashKeysSanitizer.new(whitelist: [:name, address: [:street, :city, email: [:type]]])
    sanitized_params = sanitizer.sanitize(name: 'John', unknown: 'dummy', 
                                          address: { street: "John Street", unknown: "BANG",
                                                     email: { type: 'job', unknown: 'BANG' } })
    p sanitized_params 
    {:name=>"John", :address=>{:street=>"John Street", :email=>{:type=>"job"}}}
    
The whitelist and hash can have stringified or symbolized keys. All combinations are supported.
     
