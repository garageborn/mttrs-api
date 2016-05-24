require 'rails_helper'

RSpec.describe SocialCounterUpdateJob do
  let(:story) { create(:story) }
  let(:job) { SocialCounterUpdateJob.new(story.id) }
  before { allow(job).to receive(:story).and_return(story) }

  describe '#update' do
    let(:social_counter) { build(:social_counter, story: story, facebook: 3, linkedin: 3) }

    context 'all providers response' do
      let(:social) { OpenStruct.new(facebook: 2, linkedin: 4) }
      before do
        allow(job).to receive(:social_counter).and_return(social_counter)
        allow(job).to receive(:social).and_return(social)
        job.send(:update)
      end
      subject { social_counter }
      its(:facebook) { is_expected.to eql(3) }
      its(:linkedin) { is_expected.to eql(4) }
    end

    context 'single provider response' do
      let(:social) { OpenStruct.new(linkedin: 4) }
      before do
        allow(job).to receive(:social_counter).and_return(social_counter)
        allow(job).to receive(:social).and_return(social)
        job.send(:update)
      end
      subject { social_counter }
      its(:facebook) { is_expected.to eql(3) }
      its(:linkedin) { is_expected.to eql(4) }
    end

    context 'empty response' do
      let(:social) { OpenStruct.new }
      before do
        allow(job).to receive(:social_counter).and_return(social_counter)
        allow(job).to receive(:social).and_return(social)
        job.send(:update)
      end
      subject { social_counter }
      its(:facebook) { is_expected.to eql(3) }
      its(:linkedin) { is_expected.to eql(3) }
    end
  end

  describe '#update_counter' do
    let(:social_counter) { build(:social_counter, story: story, facebook: 3, linkedin: 3) }
    before { allow(job).to receive(:social_counter).and_return(social_counter) }
    subject { social_counter }

    empty_values = [nil, '0', 0, -1]
    lower_values = [1, 2, 3]
    greater_values = [4, 5]

    empty_values.each do |value|
      context "#{ value } value" do
        before { job.send(:update_counter, 'facebook', value) }
        its(:facebook) { is_expected.to eql(3) }
      end
    end

    lower_values.each do |value|
      context "#{ value } value" do
        before { job.send(:update_counter, 'facebook', value) }
        its(:facebook) { is_expected.to eql(3) }
      end
    end

    greater_values.each do |value|
      context "#{ value } value" do
        before { job.send(:update_counter, 'facebook', value) }
        its(:facebook) { is_expected.to eql(value) }
      end
    end
  end
end
