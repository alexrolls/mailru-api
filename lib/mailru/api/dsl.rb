module MailRU
  class API
    class DSL
      def initialize api, group,  &block
        @api = api
        @group = group
        instance_eval(&block) if block_given?
      end

      def api name, method = :get, secure = Request::Secure::Any, params={}
        raise Error.create(0, 'HTTP method must be GET or POST!') unless [:get, :post].include?(method)

        __send__(:define_singleton_method, underscore(name)) do
          return @api.send(method, "#{@group}.#{name}", params, secure)
        end
      end

      private

      def underscore s
        s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end
