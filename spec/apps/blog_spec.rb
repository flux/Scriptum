require_relative '../spec_helper'

describe Scriptum::BlogApp, :type => :request do
  
  it "should list tumblelog content" do
    create(:article, :title => 'my article')
    create(:link, :title => 'my link')
    visit "/"
    page.should have_content('my article')
    page.should have_content('my link')
  end
  
  it "should not list unpublished posts" do
    create(:article, :title => 'my article', :published => false)
    visit "/"
    page.should_not have_content('my article')
  end
  
  it "should show individual posts" do
    a = create(:article)
    visit "/post/#{a.slug}"
    page.should have_content(a.title)
  end

  it "should show 404 if post not found" do
    visit "/post/non-existent-post"
    page.should have_content(404)
  end
  
end
