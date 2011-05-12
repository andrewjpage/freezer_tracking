class Search
  include ActiveModel::Validations
  attr_reader :query
  attr_reader :assets, :storage_areas, :freezers, :building_areas
  
  validates_presence_of :query
  
  def initialize(attributes = {})
     @query = attributes[:query]
  end
  
  def search_terms
    @search_terms ||= split_query(self.query)
  end
  
  def split_query(query_string)
    return [] if query_string.blank?
    query_string.split(/\W/)
  end
  
  SEARCHABLE_CLASSES = [ Asset, StorageArea, Freezer, BuildingArea ]
  # extract to GEM
  def searchable_classes
    SEARCHABLE_CLASSES
  end
  
  def perform_search
    searchable_classes.each do |clazz|
      instance_variable_set("@#{ clazz.name.underscore.pluralize }", clazz.for_search_query(search_terms).all)
    end
  end

  def each_non_empty_search_result(&block)
    searchable_classes.each do |clazz|
      results = instance_variable_get("@#{ clazz.name.underscore.pluralize }")
      yield(clazz.name.underscore.pluralize, results) unless results.blank?
    end
  end
  
end
