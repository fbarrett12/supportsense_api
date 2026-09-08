module Api
  module V1
    class TicketsController < ApplicationController
      # TODO: add auth & current_organization
      before_action :set_ticket, only: [:show, :update, :link_known_issue]

      def index
        tickets = current_organization.tickets.order(created_at: :desc).limit(100)
        render json: tickets.map { |t| TicketSerializer.new(t).as_json }
      end

      def show
        render json: TicketSerializer.new(@ticket).as_json.merge(
          known_issue: @ticket.known_issue&.as_json(only: [:id, :title, :severity_level, :status, :root_cause, :workaround])
        )
      end

      def create
        ticket = current_organization.tickets.new(ticket_params)

        if ticket.save
          TicketEnrichmentJob.perform_now(ticket.id)
          render json: TicketSerializer.new(ticket.reload).as_json, status: :created
        else
          render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @ticket.update(ticket_params)
          render json: @ticket
        else
          render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def link_known_issue
        known_issue = current_organization.known_issues.find(params[:known_issue_id])
        @ticket.update!(known_issue: known_issue)
        known_issue.update_occurrence_stats!
        render json: { ticket_id: @ticket.id, known_issue_id: known_issue.id }
      end

      private

      def set_ticket
        @ticket = current_organization.tickets.find(params[:id])
      end

      # Stub for now – later wired to auth/tenant logic
      def current_organization
        @current_organization ||= Organization.first
      end

      def ticket_params
        params.require(:ticket).permit(
          :external_id,
          :source_system,
          :subject,
          :body,
          :status,
          :severity,
          :customer_identifier,
          tags: []
        )
      end
    end
  end
end
