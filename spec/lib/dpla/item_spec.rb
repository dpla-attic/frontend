require 'spec_helper'

describe DPLA::Item do
  subject { DPLA::Item }

  context 'preparing_conditions' do
    context 'string' do
      it 'should uri encode string' do
        prepare_conditions('new york').should eql('new%20york')
      end
    end

    context 'array' do
      it 'should uri encode elements' do
        prepare_conditions(['new york']).should eql('new%20york')
      end

      it 'should join elements by slash' do
        prepare_conditions(['some string', 'new york'])
          .should eql('some%20string/new%20york')
      end
    end

    context 'hash' do
      it 'should uri encode elements' do
        prepare_conditions(q: 'new york')
          .should eql('q=new%20york')
      end

      it 'should transform hash to uri params' do
        prepare_conditions(q: 'new york', subject: 'City Library')
          .should eql('q=new%20york&subject=City%20Library')
      end

      it 'should flatten nested hashes to dot-separated keys' do
        prepare_conditions(created: {start: '1980-12-10', end: '2000-12-12'})
          .should eql('created.start=1980-12-10&created.end=2000-12-12')
      end

      it 'should join :facets and :fields arrays by comma' do
        prepare_conditions(facets: ['spatial', 'language'])
          .should eql('facets=spatial,language')
        prepare_conditions(fields: ['id', 'subject', 'description'])
          .should eql('fields=id,subject,description')
      end

      it 'should join array values by +AND+' do
        prepare_conditions(language: ['English', 'Russian'], type: ['text', 'image'])
          .should eql('language=English+AND+Russian&type=text+AND+image')
      end

      it 'should wrap :subject values by doublequotes' do
        prepare_conditions(subject: ['Ships', 'Shipyards', "New York"])
          .should eql('subject="Ships"+AND+"Shipyards"+AND+"New%20York"')
      end

      it 'should not wrap :sort_by, :sort_order, :page, :page_size by doublequotes' do
        prepare_conditions(sort_by: 'subject.name', sort_order: :asc, page: 2, page_size: 20)
          .should eql('sort_by=subject.name&sort_order=asc&page=2&page_size=20')
      end
    end

    def prepare_conditions(*args)
      subject.send :prepare_conditions, *args
    end
  end
end