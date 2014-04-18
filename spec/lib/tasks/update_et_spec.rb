require_relative '../../../lib/tasks/update_et'

describe Tasks::UpdateEt do

  let(:update_et) { Tasks::UpdateEt.new 'http://weather.nmsu.edu/ws/data/etform' }
  let(:page) { File.read(File.join('spec', 'fixtures', 'page.html')) }

  describe '#initialize' do

    it 'stores a URL' do
      expect(update_et.url).to eq 'http://weather.nmsu.edu/ws/data/etform'
    end

  end

  describe '#parse' do

    let(:parsed_page) { update_et.parse(page) }

    it 'extracts the link' do
      link = 'http://mashable.com/2012/07/18/ipad-early-photos/comment-page-1/#comment-18239503'
      expect(comment[:link]).to eq link
    end

    it 'extracts the title' do
      title = 'Comment on The Earliest Photos of Apple’s iPad Hit the Web by Fido'
      expect(comment[:title]).to eq title
    end

  end

end