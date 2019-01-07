require "test_helper"

class TicketTrackerAdatersApiTest < ActiveSupport::TestCase
  attr_reader :adapter, :connection, :ticket


  context "Houston::Adapters::TicketTracker.adapters" do
    should "find the Unfuddle adapter" do
      assert_includes Houston::Adapters::TicketTracker.adapters, "Unfuddle"
    end

    should "also find the default adapters" do
      assert_includes Houston::Adapters::TicketTracker.adapters, "None"
      assert_includes Houston::Adapters::TicketTracker.adapters, "Houston"
    end
  end


  context "UnfuddleAdapter" do
    setup do
      @adapter = Houston::Adapters::TicketTracker.adapter("Unfuddle")
    end

    should "respond to the TicketTracker::Adapter interface" do
      assert_respond_to adapter, :errors_with_parameters
      assert_respond_to adapter, :build
      assert_respond_to adapter, :parameters
    end
  end


  context "UnfuddleAdapter::Connection" do
    setup do
      adapter = Houston::Adapters::TicketTracker.adapter("Unfuddle")
      @connection = adapter.build(Project.new, 1).extend(FeatureSupport)
    end

    should "respond to the TicketTracker::Connection interface" do
      assert_respond_to connection, :features
      assert_respond_to connection, :build_ticket # <-- for creating a TicketTracker::Ticket from a native ticket,
                                                  #     used internally except for this test...
      assert_respond_to connection, :create_ticket! # <-- for creating a remote ticket from attributes
      assert_respond_to connection, :find_ticket_by_number
      assert_respond_to connection, :project_url
      assert_respond_to connection, :ticket_url

      if connection.supports? :syncing_tickets
        assert_respond_to connection, :find_tickets_numbered
        assert_respond_to connection, :all_tickets
        assert_respond_to connection, :open_tickets
      end

      if connection.supports? :syncing_milestones
        assert_respond_to connection, :all_milestones
        assert_respond_to connection, :open_milestones
      end
    end
  end


  context "UnfuddleAdapter::Ticket" do
    setup do
      adapter = Houston::Adapters::TicketTracker.adapter("Unfuddle")
      connection = adapter.build(Project.new, 1).extend(FeatureSupport)
      @ticket = connection.build_ticket({})
    end

    should "respond to the TicketTracker::Ticket interface" do
      assert_respond_to ticket, :remote_id
      assert_respond_to ticket, :number
      assert_respond_to ticket, :summary
      assert_respond_to ticket, :description
      assert_respond_to ticket, :reporter_email
      assert_respond_to ticket, :milestone_id
      assert_respond_to ticket, :type
      assert_respond_to ticket, :tags
      assert_respond_to ticket, :created_at
      assert_respond_to ticket, :closed_at

      assert_respond_to ticket, :close!
      assert_respond_to ticket, :reopen!
    end
  end

end
