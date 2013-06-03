require 'spec_helper'
require 'ostruct'

RSpec.configure do |c|
  # declare an exclusion filter
  c.filter_run_excluding :list
end

describe SMS do

  context "can process req with dosage in form of ' ' separation" do  
    data = {
        :From => '+15555555555',
        :Body => '111111 aceta 30mg 50 ACCRA'
      }	
  	subject { OpenStruct.new SMS.parse(data).data }

  	its( :phone )        { should eq '+15555555555' }
  	its( :pcvid )        { should eq '111111' }
  	its( :shortcode )    { should eq 'aceta' }
  	its( :qty )          { should eq '50' }
  	its( :loc )          { should eq 'ACCRA' }
  	its( :dosage_value ) { should eq '30' }
  	its( :dosage_units ) { should eq 'mg' }
  end

  context "can process req with dosage in form of ', ' separation" do
    data = {
        :From => '+15555555555',
        :Body => '111111, aceta, 30mg, 50, ACCRA'
      }
    subject { OpenStruct.new SMS.parse(data).data }

    its( :phone )        { should eq '+15555555555' }
    its( :pcvid )        { should eq '111111' }
    its( :shortcode )    { should eq 'aceta' }
    its( :qty )          { should eq '50' }
    its( :loc )          { should eq 'ACCRA' }
    its( :dosage_value ) { should eq '30' }
    its( :dosage_units ) { should eq 'mg' }
  end

  context "can process req with dosage in form of ',' separation" do
    data = {
        :From => '+15555555555',
        :Body => '111111,aceta,30mg,50,ACCRA'
      }
    subject { OpenStruct.new SMS.parse(data).data }

    its( :phone )        { should eq '+15555555555' }
    its( :pcvid )        { should eq '111111' }
    its( :shortcode )    { should eq 'aceta' }
    its( :qty )          { should eq '50' }
    its( :loc )          { should eq 'ACCRA' }
    its( :dosage_value ) { should eq '30' }
    its( :dosage_units ) { should eq 'mg' }
  end

  context "can process req without dosage in form of ' ' separation" do  
    data = {
        :From => '+15555555555',
        :Body => '111111 bandg 50 ACCRA'
      } 
    subject { OpenStruct.new SMS.parse(data).data }

    its( :phone )        { should eq '+15555555555' }
    its( :pcvid )        { should eq '111111' }
    its( :shortcode )    { should eq 'bandg' }
    its( :qty )          { should eq '50' }
    its( :loc )          { should eq 'ACCRA' }
  end

  context "can process req without dosage in form of ', ' separation" do
    data = {
        :From => '+15555555555',
        :Body => '111111, bandg, 50, ACCRA'
      }
    subject { OpenStruct.new SMS.parse(data).data }

    its( :phone )        { should eq '+15555555555' }
    its( :pcvid )        { should eq '111111' }
    its( :shortcode )    { should eq 'bandg' }
    its( :qty )          { should eq '50' }
    its( :loc )          { should eq 'ACCRA' }
  end

  context "can process req without dosage in form of ',' separation" do
    data = {
        :From => '+15555555555',
        :Body => '111111,bandg,50,ACCRA'
      }
    subject { OpenStruct.new SMS.parse(data).data }

    its( :phone )        { should eq '+15555555555' }
    its( :pcvid )        { should eq '111111' }
    its( :shortcode )    { should eq 'bandg' }
    its( :qty )          { should eq '50' }
    its( :loc )          { should eq 'ACCRA' }
  end

  context "can process list request", :list do  
    data = {
        :From => '+15555555555',
        :Body => 'list?'
      } 
    subject { OpenStruct.new SMS.parse(data).data }

    its( :to )   { should eq '+15555555555' }
    its( :body ) { should eq 'meds, units, country' }
  end

  context "can process list units", :list do  
    data = {
        :From => '+15555555555',
        :Body => 'list units'
      } 
    subject { OpenStruct.new SMS.parse(data).data }

    its( :to )   { should eq '+15555555555' }
    its( :body ) { should eq 'mg, g, ml' }
  end

  context "can process list country", :list do  
    data = {
        :From => '+15555555555',
        :Body => 'list ghana'
      } 
    subject { OpenStruct.new SMS.parse(data).data }

    its( :to )   { should eq '+15555555555' }
    its( :body ) { should eq 'one, two, three' }
  end
  
end