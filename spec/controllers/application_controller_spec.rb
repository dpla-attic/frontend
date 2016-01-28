require 'spec_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render nothing: true, status: 200 and return
    end
  end

  before do
    allow(subject).to receive(:current_user)
  end


  context 'with a valid back_uri parameter' do
    it 'renders 200 OK' do
      get :index, back_uri: 'http://test.host/nice'
      expect(response.status).to eq(200)
    end
  end

  context 'with an offsite back_uri parameter' do
    it 'renders 403 Forbidden' do
      get :index, back_uri: 'http://badsite.com/spam'
      expect(response.status).to eq(403)
    end
  end
end
