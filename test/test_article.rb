require 'helper'
require 'als_typograf/active_record'
require 'pp'

load_schema

class Article < ActiveRecord::Base
  validates_presence_of :title
  typograf(:content)
  typograf(:title => {:use_p => false, :use_br => false})
end
pp Article.typograf_fields

class TestArticle < Test::Unit::TestCase
  def self.described_type; Article end

  should_have_class_methods :typograf
  should_have_instance_methods :typograf_fields

  should 'load schema correctly' do
    assert_equal [], Article.all
  end

  context 'with an Article' do
    setup do
      @article = Article.create(:title => '- Does it "Article"?',
                                :content => '- Yes, this is an "Article"...')
    end

    should 'typograf article’s content with default options' do
      assert_equal '<p>&#151; Yes, this is&nbsp;an&nbsp;&laquo;Article&raquo;&#133;</p>', @article.content
    end

    should 'typograf article’s title with custom options' do
      assert_equal '&#151; Does it&nbsp;&laquo;Article&raquo;?', @article.title
    end
  end
end