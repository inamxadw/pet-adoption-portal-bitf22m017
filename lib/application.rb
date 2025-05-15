# Custom application methods and monkey patches
module ApplicationExtensions
  # Clear all Rails caches
  def self.clear_caches
    Rails.cache.clear if Rails.cache.respond_to?(:clear)
    Rails.application.assets.cache.clear if Rails.application.assets && Rails.application.assets.respond_to?(:cache) && Rails.application.assets.cache.respond_to?(:clear)
  end

  # Helper to check if running on Windows
  def self.windows?
    Gem.win_platform? || RUBY_PLATFORM =~ /mswin|mingw|cygwin/
  end
  
  # Helper to set proper file permissions
  def self.ensure_directory_permissions(path)
    return unless Dir.exist?(path)
    return unless windows?
    
    require 'open3'
    Open3.capture3("icacls \"#{path}\" /grant Everyone:F /t")
  end
end

# Try to ensure cache directories have proper permissions
Rails.application.config.to_prepare do
  cache_path = Rails.root.join('tmp', 'cache')
  FileUtils.mkdir_p(cache_path) unless Dir.exist?(cache_path)
  
  if ApplicationExtensions.windows?
    ApplicationExtensions.ensure_directory_permissions(cache_path)
  end
end 