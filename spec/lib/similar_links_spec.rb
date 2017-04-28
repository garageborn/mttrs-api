require 'rails_helper'

RSpec.describe SimilarLinks do
  context 'Blocked Links' do
    let(:category) { create(:category) }
    let(:first_story) { create(:story, category: category) }
    let(:second_story) { create(:story, category: category) }
    let(:first_link) { create(:link, category: category, story: first_story) }
    let(:second_link) { create(:link, category: category, story: second_story) }
    let(:third_story) { create(:story, category: category) }
    let(:third_link) { create(:link, category: category, story: third_story) }

    describe 'no blocked' do
      let(:response) { build_elasticsearch_response(Link, [first_link, second_link, third_link]) }
      before { allow(first_link).to receive(:find_similar).and_return(response) }
      subject { first_link.similar }
      its(:links) { is_expected.to include(first_link, second_link, third_link) }
    end

    describe 'single level' do
      let(:response) { build_elasticsearch_response(Link, [first_link, second_link, third_link]) }
      before do
        create(:blocked_story_link, link: first_link, story: second_story)
        allow(first_link).to receive(:find_similar).and_return(response)
      end
      subject { first_link.similar }
      its(:links) { is_expected.to include(first_link, third_link) }
      its(:links) { is_expected.to_not include(second_link) }
      its(:blocked_links) { is_expected.to include(second_link.id) }
    end

    describe '2 levels' do
      let(:response) { build_elasticsearch_response(Link, [first_link, second_link, third_link]) }
      before do
        create(:blocked_story_link, link: second_link, story: third_story)
        allow(first_link).to receive(:find_similar).and_return(response)
      end
      subject { first_link.similar }
      its(:links) { is_expected.to include(first_link) }
      its(:links) { is_expected.to include(second_link) }
      its(:links) { is_expected.to_not include(third_link) }
      its(:blocked_links) { is_expected.to include(third_link.id) }
    end
  end
end
