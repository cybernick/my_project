require 'spec_helper'

describe "Pages" do

  subject { page }

  shared_examples_for "all pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading) { 'Hotels'}
    let(:page_title) {'Home'}
    it_should_behave_like "all pages"
    before(:all) { 5.times { FactoryGirl.create(:hotel) } }
    after(:all)  { Hotel.delete_all }
    it "should list top 5 rated hotel" do
        Hotel.order("rating DESC").limit(5).each do |hotel|
          expect(page).to have_selector('li', text: hotel.title)
          expect(page).to have_selector('li', text: hotel.room_description)
          expect(page).to have_selector('li', text: hotel.country)
          expect(page).to have_selector('li', text: hotel.state)
          expect(page).to have_selector('li', text: hotel.city)
          expect(page).to have_selector('li', text: hotel.street)
          expect(page).to have_selector('li', text: hotel.rating)
        end
      end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading) { 'Help'}
    let(:page_title) {'Help'}
    it_should_behave_like "all pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading) { 'About'}
    let(:page_title) {'About Us'}
    it_should_behave_like "all pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading) { 'Contact'}
    let(:page_title) {'Contact'}
    it_should_behave_like "all pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign Up"
    expect(page).to have_title(full_title('Sign up'))
    click_link "Hotels"
    expect(page).to have_title(full_title('Home'))
  end
end