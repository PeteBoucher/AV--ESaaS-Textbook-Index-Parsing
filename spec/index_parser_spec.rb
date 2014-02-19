# spec/your_class_spec.rb
require 'spec_helper'
require 'index_parser.rb'
# require '../lib/'

describe 'Parser' do
  before :each do
    @parser = Parser.new
  end

  let(:parser) { @parser }

  it 'should assign index_items' do
    parser.parse '<INDEX><GROUP><H0>content</H0></GROUP></INDEX>'
    expect(assign: @index_items).to_not be_nil
    expect(parser.H0).to_not be_nil
  end

  it 'should assign index_items even with bold in ' do
    parser.parse '<INDEX><GROUP><B>A</B></GROUP></INDEX>'
    expect(assign: @index_items).to_not be_nil
    expect(parser.group.text).to eq 'A'
  end

  it 'should assign an index item with a page number' do
    parser.parse '<INDEX><GROUP><H0>Accessor method, Ruby objects, <PAGE>79</PAGE></H0></GROUP></INDEX>'
    expect(assign: @index_items).to_not be_nil
    expect(parser.index_items[0]).to eq({H0: "Accessor method, Ruby objects", H1: nil, H2: nil, page: 79, group: "", :I => false, raw: "<H0>Accessor method, Ruby objects, <PAGE>79</PAGE></H0>", :latex => %q{\index{Accessor method, Ruby objects}}})
  end

  it 'should assign multiple index items with a page number under the same heading' do
    parser.parse '<INDEX><GROUP><H0>ABC score</H0>
<H1>definition, <PAGE>310</PAGE></H1><H1>example, <PAGE><I>310</I></PAGE></H1></GROUP></INDEX>'
    expect(assign: @index_items).to_not be_nil
    expect(parser.index_items[0]).to eq({:H0 => "ABC score", :H1 => "definition", :H2 => nil, :page => 310, :group => "", :I => false, :raw => "<H1>definition, <PAGE>310</PAGE></H1>", :latex => %q{\index{ABC score!definition}}})
    expect(parser.index_items[1]).to eq({:H0 => "ABC score", :H1 => "example", :H2 => nil, :page => 310, :group => "", :I => true, :raw => "<H1>example, <PAGE><I>310</I></PAGE></H1>", :latex => %q{\index{ABC score!example|textit}}})
  end

  it 'should assign an index item with a page number and italics' do
    parser.parse '<INDEX><GROUP><H0>ActiveModel, validation, <PAGE><I>137</I></PAGE></H0></GROUP></INDEX>'
    expect(assign: @index_items).to_not be_nil
    expect(parser.index_items[0]).to eq({:H0 => "ActiveModel, validation", :H1 => nil, :H2 => nil, :page => 137, :group => "", :I => true, :raw => "<H0>ActiveModel, validation, <PAGE><I>137</I></PAGE></H0>", :latex => %q{\index{ActiveModel, validation|textit}}})
  end

  xit 'should handle italics in index entries' do
    parser.parse '<INDEX><GROUP><H0>Amazon</H0><H1>SOA <I>vs.</I> siloed software, <PAGE>7</PAGE></H1></GROUP></INDEX>'
    expect(assign: @index_items).to_not be_nil
    expect(parser.index_items[0]).to eq({:H0 => "Amazon", :H1 => "SOA siloed software", :H2 => nil, :page => 7, :group => "", :raw => "<H1>SOA <I>vs.</I> siloed software, <PAGE>7</PAGE></H1>", :I => false, :latex => %q{\index{Amazon!SOA \textit{vs.} Siloed software}}})
  end
end
