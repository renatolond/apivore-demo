require 'rails_helper'

RSpec.describe 'the API', type: :apivore, order: :defined do
  subject { Apivore::SwaggerChecker.instance_for('/swagger.json') }

  before do
    @pet = create(:pet, name: "Doggo")
  end

  context 'has valid paths' do
    describe "get information about a pet" do
      it "try to get a non-existing pet" do
        params = { "petId" => Pet.maximum(:id) + 1 }

        expect(subject).to validate(
          :get, '/pets/{petId}', 404, params
        )
      end

      it "uses an invalid pet id" do
        params = { "petId" => "banana" }

        expect(subject).to validate(
          :get, '/pets/{petId}', 400, params
        )
      end

      it "gets an existing pet" do
        params = { "petId" => @pet.id }

        expect(subject).to validate(
          :get, '/pets/{petId}', 200, params
        )
      end
    end
    describe "create a pet" do
      it "creates a valid pet" do
        body = { "pet" => {"name" => "Hulk", "photo_urls": ["url1", "url2"], "status" => "available" } }

        expect(subject).to validate(
          :post, '/pets', 201, { "_data" => body }
        )
      end
    end
  end

  context 'and' do
    it 'tests all documented routes' do
      expect(subject).to validate_all_paths
    end
  end
end
