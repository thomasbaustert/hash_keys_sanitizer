[![Build Status](https://travis-ci.org/thomasbaustert/hash_keys_sanitizer.svg?branch=master)](https://travis-ci.org/thomasbaustert/hash_keys_sanitizer)

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

The sanitizer is initialized with the whitelist, for example: 

    HashKeysSanitizer.new(whitelist: [:name, address: [:street, :city, email: [:type]]])

The whitelist contains the permitted (nested keys). In the example above the top level keys `name` 
and `address` are permitted. For the key `address` the nested keys `street`, `city` and `email` are
permitted. And for `email` the nested key `type` is permitted.

To sanitizes the hash call `sanitize` and pass the hash:

    sanitized_params = sanitizer.sanitize(name: 'John', unknown: 'dummy', 
                                          address: { street: "John Street", unknown: "BANG",
                                                     email: { type: 'job', unknown: 'BANG' } })
    p sanitized_params 
    {:name=>"John", :address=>{:street=>"John Street", :email=>{:type=>"job"}}}
    
The whitelist and hash can have stringified or symbolized keys. All combinations are supported.
     
