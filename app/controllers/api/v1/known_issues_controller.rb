module Api
  module V1
    class KnownIssuesController < ApplicationController
      before_action :set_known_issue, only: [:show, :update]

      def index
        issues = current_organization.known_issues.order(occurrence_count: :desc)
        render json: issues.as_json(only: [
          :id, :title, :severity_level, :status,
          :occurrence_count, :first_seen_at, :last_seen_at
        ])
      end

      def show
        render json: @known_issue.as_json(
          include: {
            tickets: {
              only: [:id, :subject, :status, :severity, :customer_identifier, :created_at]
            }
          }
        )
      end

      def create
        issue = current_organization.known_issues.new(known_issue_params)

        if issue.save
          render json: issue, status: :created
        else
          render json: { errors: issue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @known_issue.update(known_issue_params)
          render json: @known_issue
        else
          render json: { errors: @known_issue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_known_issue
        @known_issue = current_organization.known_issues.find(params[:id])
      end

      def current_organization
        @current_organization ||= Organization.first
      end

      def known_issue_params
        params.require(:known_issue).permit(
          :title,
          :description,
          :root_cause,
          :workaround,
          :permanent_fix,
          :severity_level,
          :status,
          tags: []
        )
      end
    end
  end
end
