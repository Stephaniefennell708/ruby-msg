require 'mapi/convert/note'
require 'mapi/convert/contact'

module Mapi
	class Message
		CONVERSION_MAP = {
			'text/x-vcard'   => [:to_vcard, 'vcf'],
			'message/rfc822' => [:to_tmail, 'eml']
			# ...
		}

		# get the mime type of the message. 
		def mime_type
			case props.message_class #.downcase <- have a feeling i saw other cased versions
			when 'IPM.Contact'
				# apparently "text/directory; profile=vcard" is what you're supposed to use
				'text/x-vcard'
			when 'IPM.Note'
				'message/rfc822'
			else
				warn 'unknown message_class - %p' % props.message_class
				nil
			end
		end	

		def convert
			type = mime_type
			unless pair = CONVERSION_MAP[type]
				raise 'unable to convert message with mime type - %p' % type
			end
			send pair.first
		end
	end
end
