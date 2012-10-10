namespace :updater do
  
  task :all => [:add_link_type]
  
  desc 'Add link_type to data field for link action items'
  task :add_link_type => :environment do
    ActionItem.where(:action_type => "link").each do |action_item|
      unless action_item.data.nil?
        unless action_item.data["link_type"].present?
          item_data = action_item.data
          link_type = action_item.data["internal_link"].present? ? "internal" : "external"
          action_item.update_attributes :data => item_data.merge({"link_type" => link_type})
        end
      end
    end
  end
  
end