require 'rails_helper'

describe "Beers", '#index', type: :request do
  let(:params)  { {} }
  let(:headers) { { 'Authorization': "Bearer #{jwt_token}" } }

  subject { get beers_path, headers: headers, params: params }

  context 'when a signed in user' do
    let!(:user)         { create :user }
    let!(:jwt_token)    { Auth::JsonWebToken.encode(user.to_token) }
    let(:json_response) { JSON.parse response.body }

    context 'has all beers stored in the application' do
      it 'successfuly recovers beers belonging to user' do
        subject
        expect(json_response['beers'].length).to eq 25
      end

      it 'does not create new beers in the database' do
        get beers_path, headers: headers, params: params
        expect{ subject }.not_to change { Beer.count }.from(25)
      end

      it 'does not create new user_beers in the database' do
        get beers_path, headers: headers, params: params
        expect{ subject }.not_to change { user.beers.count }.from(25)
      end

      context 'and is filtering by name' do
        let!(:beer)   { build :beer }
        let!(:params) { { query: beer.name } }

        it 'successfuly recovers correct user beers' do
          subject
          expect(json_response["beers"].length).to eq 1
          expect(json_response["beers"].first["name"]).to eq beer.name
        end
      end

      context 'and is filtering by abv' do
        let!(:beer)   { build :beer }
        let!(:params) { { query: beer.abv } }

        it 'successfuly recovers correct user beers' do
          subject
          expect(json_response["beers"].length).to eq 3
          expect(json_response["beers"].map{ |i| i['name'] }).to include beer.name
        end
      end
    end

    context 'does not have beers stored in the application' do
      it 'successfuly saves & recovers user beers' do
        expect{ subject }.to change { user.beers.count }.by(25)
        expect(response).to be_successful
      end
    end
  end
end

describe "Beers", '#show' do
  let!(:user)   { create :user }
  let(:headers) { { 'Authorization': "Bearer #{jwt_token}" } }
  let! :expected_beer_response do
    { "id"=>1,
      "name"=>"Buzz",
      "tagline"=>"A Real Bitter Experience.",
      "description"=>"A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.",
      "abv"=>4.5,
      "created_at"=>String,
      "updated_at"=>String,
      "seen_at"=>String }
  end

  subject { get beer_path(1), headers: headers  }

  context 'when signed in user' do
    let!(:user)         { create :user }
    let!(:jwt_token)    { Auth::JsonWebToken.encode(user.to_token) }
    let(:json_response) { JSON.parse response.body }

    context 'has beer stored in database' do
      let!(:user_beer) { create :user_beer, user: user, beer: beer }

      context 'and beer has changed' do
        let!(:beer)   { create :corona, id: 1 }

        it 'does not create a new UserBeer' do
          expect{ subject }.not_to change { UserBeer.count }
        end

        it 'changes beer name' do
          expect{ subject }.to change { beer.reload.name }
        end

        it 'returns a JSON user_beer' do
          subject
          expect(json_response['beer']).to be_present
          expect(json_response['beer']).to include(expected_beer_response)
        end

        it 'returns a JSON user_beer' do
          subject
          expect(json_response['beer']).to be_present
          expect(json_response['beer']).to include()
        end
      end

      context "and beer hasn't changed" do
        let!(:beer)   { create :beer, id: 1 }

        it 'does not create a new UserBeer' do
          expect{ subject }.not_to change { UserBeer.count }
        end

        it 'does not changes beer name' do
          expect{ subject }.not_to change { beer.reload.name }
        end

        it 'returns a JSON user_beer' do
          subject
          expect(json_response['beer']).to be_present
          expect(json_response['beer']).to include(expected_beer_response)
        end
      end
    end

    context 'does not have beers stored in the application' do
      it 'associates user and beer' do
        expect { subject }.to change { user.beers.count }.by 1
      end

      it 'successfuly saves & recovers user beer' do
        expect { subject }.to change { Beer.count }.by 1
        expect(response).to be_successful
        expect(json_response['beer']).to include(expected_beer_response)
      end
    end
  end
end

describe "Beers", '#set_favorite' do
  let!(:user)   { create :user }
  let(:headers) { { 'Authorization': "Bearer #{jwt_token}" } }
  let! :expected_beer_response do
    { "id"=>1,
      "name"        => "Buzz",
      "tagline"     => "A Real Bitter Experience.",
      "description" => "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.",
      "abv"         => 4.5,
      "favorite"    => true,
      "created_at"  => String,
      "updated_at"  => String,
      "seen_at"     => String }
  end

  subject { post set_favorite_beer_path(1), headers: headers  }

  context 'when signed in user' do
    let!(:user)         { create :user }
    let!(:jwt_token)    { Auth::JsonWebToken.encode(user.to_token) }
    let(:json_response) { JSON.parse response.body }

    context 'has beer stored in database' do
      let!(:user_beer) { create :user_beer, user: user, beer: beer }

      context 'and beer has changed' do
        let!(:beer)   { create :corona, id: 1 }

        it 'does not create a new UserBeer' do
          expect{ subject }.not_to change { UserBeer.count }
        end

        it 'changes beer name' do
          expect{ subject }.to change { beer.reload.name }
        end

        it 'returns a JSON user_beer' do
          subject
          expect(json_response['beer']).to be_present
          expect(json_response['beer']).to include(expected_beer_response)
        end

        it 'returns a JSON user_beer' do
          subject
          expect(json_response['beer']).to be_present
          expect(json_response['beer']).to include(expected_beer_response)
        end
      end

      context "and beer hasn't changed" do
        let!(:beer)   { create :beer, id: 1 }

        it 'does not create a new UserBeer' do
          expect{ subject }.not_to change { UserBeer.count }
        end

        it 'does not changes beer name' do
          expect{ subject }.not_to change { beer.reload.name }
        end

        it 'returns a JSON user_beer' do
          subject
          expect(json_response['beer']).to be_present
          expect(json_response['beer']).to include(expected_beer_response)
        end
      end
    end

    context 'does not have beers stored in the application' do
      it 'associates user and beer' do
        expect { subject }.to change { user.beers.count }.by 1
      end

      it 'successfuly saves & recovers user beer' do
        expect { subject }.to change { Beer.count }.by 1
        expect(response).to be_successful
        expect(json_response['beer']).to include(expected_beer_response)
      end
    end
  end
end
