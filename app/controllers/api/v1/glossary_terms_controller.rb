module Api
  module V1
    class GlossaryTermsController < ApplicationController
      before_action :set_glossary_term, only: %i[show update]

      def index
        terms = current_organization.glossary_terms.order(:term)
        render json: terms
      end

      def show
        render json: @glossary_term
      end

      def create
        term = current_organization.glossary_terms.new(glossary_term_params)

        if term.save
          render json: term, status: :created
        else
          render json: { errors: term.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @glossary_term.update(glossary_term_params)
          render json: @glossary_term
        else
          render json: { errors: @glossary_term.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      private

      def set_glossary_term
        @glossary_term =
          current_organization.glossary_terms.find(params[:id])
      end

      def current_organization
        @current_organization ||= Organization.first
      end

      def glossary_term_params
        params.require(:glossary_term).permit(
          :term,
          :meaning,
          :internal_notes,
          tags: [],
          example_snippets: []
        )
      end
    end
  end
end