module Paperclip
  class VideoThumbnail < Processor
    attr_accessor :options

    def initialize(file, options = {}, attachment = nil)
      super
      @current_format      = File.extname(@file.path)
      @basename            = File.basename(@file.path, @current_format)
      @whiny               = options[:whiny].nil? ? true : options[:whiny]
    end

    def make
      dst = Tempfile.new [@basename, '.jpg']
      dst.binmode

      begin
        src_path = File.expand_path file.path
        dst_path = File.expand_path dst.path

        parameters = %Q[-ss 50% -i "#{src_path}" -y -vcodec mjpeg -vframes 1 -an -f rawvideo "#{dst_path}"]

        Paperclip.run('ffmpeg', parameters)
      rescue PaperclipCommandLineError => e
        raise PaperclipError, "There was an error processing the thumbnail for #{@basename}" if @whiny
      end

      dst
    end
  end
end
