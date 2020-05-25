class CreateBeers < ActiveRecord::Migration[5.2]
  def change
    create_table :beers do |t|
      t.string      :name
      t.string      :tagline
      t.text        :description
      t.float       :abv

      t.timestamps
    end
  end
end
