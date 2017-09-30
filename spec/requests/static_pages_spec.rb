require 'rails_helper'

describe "StaticPages" do
  subject { page }

  shared_examples_for "all static pages" do
    it "has correct headings" do
      expect(page).to have_selector('h1', text: heading)
      expect(page).to have_title full_title(page_title)
    end
  end
  
  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'iFarmPro' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: '| Home') }
  end

  describe "Help page" do
    
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    
    before { visit about_path }
    let(:heading) { 'About iFarmPro' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact iFarmPro' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end
end