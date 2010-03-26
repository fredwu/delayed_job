module Delayed
  module Backend
    class DeserializationError < StandardError
    end

    module Base
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Add a job to the queue
        def enqueue(*args)
          object = args.shift
          unless object.respond_to?(:perform)
            raise ArgumentError, 'Cannot enqueue items which do not respond to perform'
          end
    
          priority = args.first || 0
          run_at   = args[1] || Delayed::Worker.run_at_set_interval
          self.create(:payload_object => object, :priority => priority.to_i, :run_at => run_at)
        end
      end
      
      ParseObjectFromYaml = /\!ruby\/\w+\:([^\s]+)/

      def failed?
        failed_at
      end
      alias_method :failed, :failed?

      def payload_object
        @payload_object ||= deserialize(self['handler'])
      end

      def name
        @name ||= begin
          payload = payload_object
          if payload.respond_to?(:display_name)
            payload.display_name
          else
            payload.class.name
          end
        end
      end

      def payload_object=(object)
        self['handler'] = object.to_yaml
      end
      
      # Moved into its own method so that new_relic can trace it.
      def invoke_job
        payload_object.perform
      end
      
      # Unlock this job (note: not saved to DB)
      def unlock
        self.locked_at = nil
        self.locked_by = nil
      end
      
    private

      def deserialize(source)
        handler = YAML.load(source) rescue nil

        unless handler.respond_to?(:perform)
          if handler.nil? && source =~ ParseObjectFromYaml
            handler_class = $1
          end
          attempt_to_load(handler_class || handler.class)
          handler = YAML.load(source)
        end

        return handler if handler.respond_to?(:perform)

        raise DeserializationError,
          'Job failed to load: Unknown handler. Try to manually require the appropriate file.'
      rescue TypeError, LoadError, NameError => e
        raise DeserializationError,
          "Job failed to load: #{e.message}. Try to manually require the required file."
      end

      # Constantize the object so that ActiveSupport can attempt
      # its auto loading magic. Will raise LoadError if not successful.
      def attempt_to_load(klass)
         klass.constantize
      end

    protected

      def set_default_run_at
        self.run_at ||= self.class.db_time_now
      end
      
      def set_last_run_at_meta
        if meta = Delayed::Meta.last
          meta.update_attributes(:last_run_at => self.run_at)
        else
          Delayed::Meta.create(:last_run_at => self.run_at)
        end
      end
    
    end
  end
end