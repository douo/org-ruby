module Orgmode
  class AttachmentLinksConverter

    # :dir :id :auto
    def initialize(behavior)
      @behavior = behavior.is_a(Symbol)? behavior : behavior.to_sym if behavior
      @behavior ||= :auto
      @attachment_keyword = "attachment"
      @attachment_placeholder_regexp = /:(\w+)|:\{(\w+)\}/  # FIXME
    end

    def attachment_link? str
      @attachment_keyword == str
    end


    def convert(tag, prefix, get_property)
      folder = case @behavior
               when :auto then
                 folder_if_dir(get_property.("DIR")) || folder_if_id(get_property.("ID"))
               when :id then
                 folder_if_id(get_property.("ID"))
               when :dir then
                 folder_if_dir(get_property.("DIR"))
               end
      prefix = rewrite_prefix_link prefix do |match|
        get_property.(match) || ":#{match}"
      end

      return prefix + folder + tag
    end

    private
    def folder_if_id(id)
      return nil unless id and id.size > 2
      "#{id[..1]}/#{id[2..]}/"
    end

    def folder_if_dir(dir)
      return nil unless dir
      "#{dir}/"
    end

    # replace placeholder with properties
    # if properties not exists keep placeholder no touch
    def rewrite_prefix_link str
      str.gsub @attachment_placeholder_regexp do |match|
        # match :key || :{key}
        yield $1 || $2
      end
    end

  end
end
