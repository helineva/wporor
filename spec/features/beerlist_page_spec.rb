require 'rails_helper'

if not ENV['TRAVIS']
  describe "Beerlist page" do
    before :all do
      Capybara.register_driver :selenium do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: { args: ['headless', 'disable-gpu'] }
        )

        Capybara::Selenium::Driver.new app,
          browser: :chrome,
          desired_capabilities: capabilities
      end
      WebMock.disable_net_connect!(allow_localhost: true)
    end

    before :each do
      @brewery1 = FactoryBot.create(:brewery, name:"Koff")
      @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
      @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
      @style1 = Style.create name:"Lager"
      @style2 = Style.create name:"Rauchbier"
      @style3 = Style.create name:"Weizen"
      @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
      @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
      @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
    end

    it "shows one known beer", js:true do
      visit beerlist_path
      find('table').find('tr:nth-child(2)')
      expect(page).to have_content "Nikolai"
    end

    it "beers are sorted by name by default", js:true do
      visit beerlist_path
      table = find('table')
      expect(table.find('tr:nth-child(2)')).to have_content('Fastenbier')
      expect(table.find('tr:nth-child(3)')).to have_content('Lechte Weisse')
      expect(table.find('tr:nth-child(4)')).to have_content('Nikolai')
    end
  end
end
