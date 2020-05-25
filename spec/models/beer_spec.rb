require 'rails_helper'

describe Beer do
  context 'with valid attributes' do
    subject(:beer) { create :beer }

    it('is valid')        { is_expected.to be_valid }
    it('has abv')         { expect(subject.abv).to be_present }
    it('has name')        { expect(subject.name).to be_present }
    it('has tagline')     { expect(subject.tagline).to be_present }
    it('has description') { expect(subject.description).to be_present }
  end

  context 'with nil attributes' do
    subject(:beer) { Beer.new }
    before { is_expected.to be_invalid }

    it('has abv "can\'t be blank" error')         { expect(subject.errors[:abv]).to include "can\'t be blank" }
    it('has name "can\'t be blank" error')        { expect(subject.errors[:name]).to include "can\'t be blank" }
    it('has tagline "can\'t be blank" error')     { expect(subject.errors[:tagline]).to include "can\'t be blank" }
    it('has description "can\'t be blank" error') { expect(subject.errors[:description]).to include "can\'t be blank" }
  end
end

describe Beer, '#user_beers' do
  let!(:beer) { create :beer }
  subject { beer.user_beers }

  context 'when a beer has user_beers' do
    let!(:user_beer) { create :user_beer, beer: beer }

    it 'returns an array of user_beers' do
      is_expected.not_to be_empty
      is_expected.to all be_an UserBeer
      is_expected.to include user_beer
    end
  end

  context "when a beer doesn't have user_beers" do
    it 'returns an array of user_beers' do
      is_expected.to be_empty
    end
  end
end

describe Beer, '#users' do
  let!(:beer) { create :beer }
  subject { beer.users }

  context 'when a beer has users' do
    let!(:user) { create :user }
    let!(:user_beer) { create :user_beer, beer: beer, user: user }

    it 'returns an array of users' do
      is_expected.not_to be_empty
      is_expected.to include user
    end
  end

  context "when a beer doesn't have users" do
    it('returns an empty array') { is_expected.to be_empty }
  end
end
