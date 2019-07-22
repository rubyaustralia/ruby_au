class Admin::MembershipsController < Admin::ApplicationController
  expose(:members) { Membership.current.includes(:user) }
end
