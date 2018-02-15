module Jekyll
    class RenderAssetTag < Liquid::Tag
  
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end
  
      def render(context)
        filepath = "#{Dir.pwd}/#{@text}".strip
        if File.exist? filepath
          File.read filepath
        end
      end
    end
end
  
Liquid::Template.register_tag('render_asset', Jekyll::RenderAssetTag)