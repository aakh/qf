class CreateFactValues < ActiveRecord::Migration
  
  def self.add_item(concept, name, price, desc="", alc = nil)
    entity = Entity.create( :name => name, :price => 0, :desc => desc)
    concept.entities << entity
    price_fact = Fact.find_by_name('Price')
    fv = FactValue.create(:value => price)
    fv.fact = price_fact
    fv.entity = entity
    fv.save!
    if alc
      alc_fact = Fact.find_by_name('Alcohol content')
      fv = FactValue.create(:value => alc)
      fv.fact = alc_fact
      fv.entity = entity
      fv.save!
    end
    entity.save!
  end
  
  def self.add_dim_to_concept(dim, concept)
    concept.dimensions << dim
    
    if dim.valuable_type == "Fact"
      op = Opinion.find_by_name dim.name
      concept.dimensions << op.dimension
    end
  end
  
  def self.up
    create_table :fact_values do |t|
      t.float :value
      t.references :fact, :entity
      t.timestamps
    end
    
    
    mains = Concept.create!(:name => "Mains", :desc => "")
    starters = Concept.create!(:name => "Starters", :desc => "")
    desserts = Concept.create!(:name => "Desserts", :desc => "")
    beer = Concept.create!(:name => "Tap Beer", :desc => "")
    wine = Concept.create!(:name => "Wine", :desc => "")
    
    quality = Opinion.create
    quality.dimension = Dimension.new :name => "Quality", :desc => "Determines the degree of quality of the product."
    quality.save!
    
    price = Fact.create :template => "$# NZD"
    price.dimension = Dimension.new :name => "Price", :desc => "Determines if the price is right."
    price.save!    
    
    alc_content = Fact.create :template => "#% ABV"
    alc_content.dimension = Dimension.new :name => "Alcohol content", :desc => "Tells you how much alcohol by volume there is inside."
    alc_content.save!
    
    flavour = Opinion.create :low_text => "Nothing", :high_text => "Too much"
    flavour.dimension = Dimension.new :name => "Flavour", :desc => "Tells you if there isn't any flavour or if there's too much of it."
    flavour.save!
    
    presentation = Opinion.create :low_text => "Ugly", :high_text => "Excellent"
    presentation.dimension = Dimension.new :name => "Presentation", :desc => "Tells you if the product is nice to look at."
    presentation.save!
    
    quantity = Opinion.create :low_text => "Too little", :high_text => "Too much"
    quantity.dimension = Dimension.new :name => "Quantity", :desc => "Tells you if you get enough in a serving."
    quantity.save!
    
    [beer, wine].each do |c|
      [flavour, alc_content].each do |d|
        add_dim_to_concept d.dimension, c
      end
    end
    
    [desserts, mains, starters].each do |c|
      [presentation, quantity, flavour].each do |d|
        add_dim_to_concept d.dimension, c
      end
    end
    
    Concept.all.each do |c|
      [price, quality].each do |d|
        add_dim_to_concept d.dimension, c
      end
    end
    
    add_item(mains, "Pumpkin and feta cheese risotto", 16.5, "Roasted pumpkin, baby spinach, pistachio pesto topped with feta cheese (with smoked chicken +$3).")
    add_item(mains, "Calamari and chorizo salad", 18, "Char grilled calamari, Spanish chorizo, crispy potatoes, olives and sun-blushed tomatoes.")
    add_item(mains, "Char-grilled salad", 14, "Grilled zucchini, roasted capsicum, Spanish onion, green beans, cherry tomatoes, and feta served with capsicum (with chicken +$3).")
    add_item(mains, "Salmon Dill Fishcakes", 18.5, "Salmon and dill fishcakes served with roasted vegetables, topped with a cremy leek and fennel sauce.")
    add_item(mains, "BBQ Ribs", 18.5, "Homemade BBQ pork ribs served with coleslaw and fries.")
    add_item(mains, "Open Chicken Foccacia", 18, "Chicken breast, tomatoes, lettuce, melted brie and cranberry sauce served with fries.")
    add_item(mains, "Fettuccini Carbonara", 17, "Sauteed bacon and mushrooms in a garlic cream sauce served with parmesan and garlic bread.")
    add_item(mains, "Queens Ferry Burger", 18.5, "100% NZ lamb mince filled with feta cheese, pine nuts and rosemary topped with Tzatziki, served with fries.")
    add_item(mains, "Queens Ferry Fish & Chips", 19.5, "Monteith's beer battered tarakihi served with fries, fresh garden salad and homemade tartare sauce.")
    add_item(mains, "Chicken Parmigiana", 19.5, "Lightly crumbed corn-fed chicken breast topped with smoked ham, Napolitana sauce and melted brie served with kumara fries and house salad.")
    add_item(mains, "Pork belly", 23, "Served on a rustic parsnip and sage mash and topped with honey roasted pears and pork crackle.")
    add_item(mains, "Lamb Shanks", 21, "Slow cooked Hawke's Bay lamb shank served on a creamy mustard mash with winter vegetables and gravy.")
    add_item(mains, "Rib Eye Steak", 24, "250g rib eye cooked to your liking served with gratin potatoes, green beans wrapped in bacon and a choice of either mushroom or green peppercorn sauce.")
    
    add_item(starters, "Golden Fries", 7, "Dusted with paprika, garlic and served with aioli.")
    add_item(starters, "Kumara Chips", 8.5, "Served with spicy tomatoes chutney and aioli.")
    add_item(starters, "Seasoned Spicy Wedges", 10.5, "With bacon, cheese and sour cream.")
    add_item(starters, "Nachos", 14, "Mexican nachos served with homemade relish, sour cream, refried beans, cheddar cheese and guacamole (with chicken/beef +$2).")
    add_item(starters, "Soup of the day", 9.5, "Served with crusty bread.")
    add_item(starters, "Buffalo Wings", 13, "Served with blue cheese and spicy BBQ dipping sauce.")
    add_item(starters, "Tarakihi Goujons", 12, "Pieces of panko crumbed tarakihi served with tartare sauce.")
    add_item(starters, "Calamari Rings", 12, "Polenta crushed calamari served with salsa verde and aioli.")
    add_item(starters, "Seafood Chowder", 13.5, "Tarakihi fillets, tiger prawns, calamari and mussels in a creamy potato and sweet corn soup served with garlic bread.")
    add_item(starters, "Satay Chicken Shaslik", 12.5, "Marinated chicken tenderloins grilled and served with Turkish pita and cucumber mint yogurt.")
    
    add_item(desserts, "Chocolate Brownie", 10, "Filled with wite chocolate chips. Served warm with chocolate ice cream.")
    add_item(desserts, "Apple And Rhubarb Crumble", 10, "With cocnut and honey oat crust.")
    add_item(desserts, "Raspbery Brulee", 10, "With vodka marinated raspberries.")
    add_item(desserts, "Sticky Date Pudding", 10, "Served with caramel ice cream and toffee sauce.")
    
    add_item(wine, "Settlers Hill Sav Blanc", 8, "", 12.5)
    add_item(wine, "Oyster Bay Sav Blanc", 8.5, "", 13)
    add_item(wine, "Wither Hills Sav Blanc", 9.5, "", 13)
    add_item(wine, "Willowglen Chardonnay", 8, "", 12.5)
    add_item(wine, "Trinity Hill Chardonnay", 8.5, "", 13)
    add_item(wine, "Mt Difficulty Pinot Gris", 9, "", 13.5)
    add_item(wine, "Rockburn Resiling", 9, "", 12.5)
    
    add_item(wine, "Stoneleigh Rose", 9, "", 13)
    
    add_item(wine, "Willowglen Shiraz", 8, "", 14)
    add_item(wine, "Brookfields Merlot", 8.5, "", 14)
    add_item(wine, "Trinity Hill Syrah", 8.5, "", 13)
    add_item(wine, "Trinity Hill Cab Merlot", 8.5, "", 13.5)
    add_item(wine, "Torea Pinot Noir", 9, "", 14)
    add_item(wine, "Mt Difficulty Pinot Noir", 11, "", 13.5)
    
    add_item(beer, "Montheith's Pilsner", 8, "", 5)
    add_item(beer, "Montheith's Original", 8, "", 4)
    add_item(beer, "Montheith's Radler", 8, "", 5)
    add_item(beer, "Montheith's Golden", 8, "", 5)
    add_item(beer, "Montheith's Black", 8, "", 5.2)
    add_item(beer, "Montheith's Apple Cider", 8, "", 4.5)
    add_item(beer, "Heineken", 8.5, "", 5)
    add_item(beer, "Tiger", 8.5, "", 5)
    add_item(beer, "Murphy's", 8.5, "", 4)
    add_item(beer, "Tui", 8, "", 4)
    add_item(beer, "Export 33", 8, "", 4.6)
    
    mains.save!
    starters.save!
    desserts.save!
    beer.save!
    wine.save!
  end

  def self.down
    drop_table :fact_values
  end
end
