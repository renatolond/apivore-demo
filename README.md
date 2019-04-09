# README

This repository contains a demo of the Apivore gem for the Ruby Belgium Code Together of 9th of April of 2019.

## Step-by-step

1) An app was created with:

```
rails new apivore-demo --api --skip-test --skip-system-test --database=postgresql
```

This creates a rails app with a smaller stack (only for the API), skipping tests and system tests (because we're going to use rspec) and with a postgresql database.

2) Add `rspec-rails` to the gemfile:

```
  gem "rspec-rails", "~> 3.8.0"
```

And install the gem with

```
bundle install
```

Generate the needed rspec files with:

```
bundle exec rails generate rspec:install
```

3) Add apivore to the gemfile, after rspec:

```
  gem "apivore"
```

Install it with `bundle install` and create a new spec file `spec/requests/api_spec.rb` containing the following:

```
require 'rails_helper'

RSpec.describe 'the API', type: :apivore, order: :defined do
  subject { Apivore::SwaggerChecker.instance_for('/swagger.json') }

  context 'has valid paths' do
    # tests go here
  end

  context 'and' do
    it 'tests all documented routes' do
      expect(subject).to validate_all_paths
    end
  end
end
```

This will create a test that checks that all the documented routes in swagger are being tested. This should not work yet, as we have not created our swagger definition.

4) Add a swagger definition, you can copy the one at `public/swagger.json` which is the one at this presentation. If you use the one in swagger.json it is based on Swagger pet store and it has two documented endpoints, one for getting a pet, and the other for creating a pet.

5) Add factorybot to the gemfile:

```
  gem "factory_bot_rails"
```

This way we'll have a nice factory for our pets to be used in the tests.

5) Create a pet scaffold. For this presentation we used:

```
rails g scaffold pet name:string photo_urls:string status:string
```

We altered the generated migration so that `photo_urls` are an array and the same change has to be made at the controller level so that we are correctly validating it.


After that, we written the tests for the cases we described in the swagger docs. Getting an existing pet and creating a new pet should work without any extra work. You will need to add extra validation for validating the pet id, capturing the not found exception and finally to make sure you do not allow for two pets with the same name (which is an arbitrary limitation, just to show off how we can treat errors in POSTs.)

Feel free to ask any questions in the issues!
