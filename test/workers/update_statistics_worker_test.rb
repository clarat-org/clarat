require_relative '../test_helper'

class UpdateStatisticsWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { UpdateStatisticsWorker.new }
  let(:current_date) { Date.current }

  describe '#create_statistics_for' do
    it 'should create a creation statistic' do
      # Stub out SQL query that only works on postgres, not sqlite
      Offer.stubs(:created_at_day).returns(
        Offer.where('created_at >= ?', current_date.beginning_of_day)
          .where('created_at <= ?', current_date.end_of_day)
      )

      # basic fixture offer got created today by user 1
      Statistic.expects(:create!).with(
        topic: 'offer_created', user_id: 1, x: current_date, y: 1
      ).once
      worker.send(:create_statistics_for, 'created', 'offer', current_date)
    end

    it 'actually saves a statistic' do
      # Stub out SQL query that only works on postgres, not sqlite
      Offer.stubs(:created_at_day).returns(
        Offer.where('created_at >= ?', current_date.beginning_of_day)
          .where('created_at <= ?', current_date.end_of_day)
      )

      assert_difference 'Statistic.count', 1 do
        # basic fixture offer got created today
        worker.send(:create_statistics_for, 'created', 'offer', current_date)
      end
    end

    it 'should create an approval statistic' do
      # Stub out SQL query that only works on postgres, not sqlite
      Organization.stubs(:approved_at_day).returns(
        Organization.where('approved_at >= ?', current_date.beginning_of_day)
          .where('approved_at <= ?', current_date.end_of_day)
      )

      # 2 Organizations get created and approved
      2.times do
        FactoryGirl.create :organization, :approved,
                           approved_by: users(:researcher).id
      end
      Statistic.expects(:create!).with(
        topic: 'organization_approved', user_id: 1, x: current_date, y: 2
      ).once
      worker.send(
        :create_statistics_for, 'approved', 'organization', current_date
      )
    end

    it 'wont create anything when there were no actions that day' do
      # Stub out SQL query that only works on postgres, not sqlite
      Organization.stubs(:approved_at_day).returns(
        Organization.where('approved_at >= ?', current_date.beginning_of_day)
          .where('approved_at <= ?', current_date.end_of_day)
      )
      Statistic.expects(:create!).never
      worker.send(
        :create_statistics_for, 'approved', 'organization', current_date
      )
    end
  end

  describe '#perform' do
    it 'should call #create_statistics_for 4 times' do
      UpdateStatisticsWorker.any_instance.expects(:create_statistics_for)
        .with('created', 'offer', current_date)
      UpdateStatisticsWorker.any_instance.expects(:create_statistics_for)
        .with('approved', 'offer', current_date)
      UpdateStatisticsWorker.any_instance.expects(:create_statistics_for)
        .with('created', 'organization', current_date)
      UpdateStatisticsWorker.any_instance.expects(:create_statistics_for)
        .with('approved', 'organization', current_date)
      worker.perform
    end
  end
end
