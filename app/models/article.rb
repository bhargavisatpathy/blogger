class Article < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  def tag_list
    self.tags.collect do |tag|
      tag.name
    end.join(", ")
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end
  
  def view
    update(view_count: view_count.to_i + 1)
  end

  def self.active_months
    all.group_by {|article| article.created_at.strftime("%B") }.keys
  end


  def self.find_by_month(month)
    all.select { |article| article.created_at.strftime("%B") == month }
  end

  def self.most_popular
    all.sort_by { |article| article.view_count.to_i}.reverse
  end
end
