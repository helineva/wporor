class CreateStylesAndUpdateBeers < ActiveRecord::Migration[5.2]
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description
    end

    execute "insert into styles (name, description) values ('Weizen', 'A beer, usually top-fermented, which is brewed with a large proportion of wheat relative to the amount of malted barley.')"
    execute "insert into styles (name, description) values ('Lager', 'A beer made with bottom fermenting yeast.')"
    execute "insert into styles (name, description) values ('Pale Ale', 'Pale ale is an ale made with predominantly pale malt.')"
    execute "insert into styles (name, description) values ('IPA', 'India pale ale (IPA) is a hoppy beer style within the broader category of pale ale.')"
    execute "insert into styles (name, description) values ('Porter', 'Porter is a dark style of beer developed in London from well-hopped beers made from brown malt.')"

    change_table :beers do |t|
      t.rename :style, :old_style
    end

    change_table :beers do |t|
      t.belongs_to :style
    end

    Beer.all.each do |beer|
      s = Style.find_by name: beer.old_style
      beer['style_id'] = s.id
      beer.save
    end

    remove_column :beers, :old_style, :string
  end
end
