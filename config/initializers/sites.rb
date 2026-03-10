# frozen_string_literal: true

# Configure Zeitwerk to auto-namespace site code.
# Configures Zeitwerk autoloading for subdomain sites in sites/.

Dir[Rails.root.join("sites/*")].select { |p| File.directory?(p) }.each do |site_path|
  site_name = File.basename(site_path)
  namespace = begin
    site_name.camelize.constantize
  rescue StandardError
    Object.const_set(site_name.camelize, Module.new)
  end

  Dir["#{site_path}/app/*"].each do |app_subdir|
    next if File.basename(app_subdir) == "views"

    Rails.autoloaders.main.push_dir(app_subdir, namespace: namespace)
  end

  # Add view paths
  views_path = File.join(site_path, "app/views")
  ActionController::Base.prepend_view_path(views_path) if Dir.exist?(views_path)
end
