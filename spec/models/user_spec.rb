require 'rails_helper'

describe User, '#beers' do
  let!(:user) { create :user }
  let!(:beer) { create :beer }
  subject     { user.beers }

  context 'when beers belong to user' do
    let!(:user_beer) { create :user_beer, beer: beer, user: user }

    it('returns an array of beers') { is_expected.not_to be_empty }
    it('returns associated beers') { is_expected.to include beer }
  end

  context 'when beers do not belong to user' do
    it('returns an empty array') { is_expected.to be_empty }
  end
end

describe User, '#user_beers' do
  let!(:user) { create :user }
  let!(:beer) { create :beer }
  subject     { user.user_beers }

  context 'when user_beers belong to user' do
    let!(:user_beer) { create :user_beer, user: user }

    it('returns an array of user_beers') { is_expected.not_to be_empty }
    it('returns associated user_beers') { is_expected.to include user_beer }
  end

  context 'when user_beers do not belong to user' do
    it('returns an empty array') { is_expected.to be_empty }
  end
end
