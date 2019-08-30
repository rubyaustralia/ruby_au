class PoliciesController < ApplicationController
  expose(:policies) do
    documents.select { |document| document.context['status'] == 'published' }
  end
  expose(:policy) do
    policies.detect { |document| document.context['key'] == params[:id] }
  end

  def show
    return if policy.present?

    raise ActionController::RoutingError, "No such policy: #{params[:id]}"
  end

  private

  def documents
    ContextDocument.all_within Rails.root.join("app", "documents", "policies")
  end
end
