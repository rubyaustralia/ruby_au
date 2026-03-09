# frozen_string_literal: true

# Configure Zeitwerk to auto-namespace pack code.
# Replaces the runtime behavior of packs-rails and automatic_namespaces gems.

Dir[Rails.root.join("packs/*")].select { |p| File.directory?(p) }.each do |pack_path|
  pack_name = File.basename(pack_path)
  namespace = begin
    pack_name.camelize.constantize
  rescue StandardError
    Object.const_set(pack_name.camelize, Module.new)
  end

  Dir["#{pack_path}/app/*"].each do |app_subdir|
    next if File.basename(app_subdir) == "views"

    Rails.autoloaders.main.push_dir(app_subdir, namespace: namespace)
  end

  # Add view paths
  views_path = File.join(pack_path, "app/views")
  ActionController::Base.prepend_view_path(views_path) if Dir.exist?(views_path)
end
