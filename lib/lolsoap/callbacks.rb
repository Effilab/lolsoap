# Used to add user processing in defined hooks.
#
# @example General
#  bing_ads_callbacks = LolSoap::Callbacks.new
#  bing_ads_callbacks.for('hash_params.before_build') << lambda do |args, node, type|
#    # I want to use snake case !
#    matcher = type.elements.keys.map { |name| name.tr('_', '').downcase }
#    args.each do |h|
#      found_at = matcher.index(h[:name].tr('_', '').downcase)
#      h[:name] = type.elements.keys[found_at] if found_at
#    end
#    # This API accepts the nodes only in the right order.
#    args.sort_by! { |h| type.elements.keys.index(h[:name]) || 1 / 0.0 }
#  end
#
# @example Managing callback sets
# bing_ads_callbacks.disable
# google_ads_callbacks.enable
#
class LolSoap::Callbacks

  class Store
    class << self
      def storage
        Thread.current[:registered_callbacks] ||= []
      end

      def in(key)
        storage.flat_map do |c|
          c.callbacks[key]
        end.compact
      end

      def enable(klass)
        return storage if storage.include?(klass)
        storage.push(klass)
      end

      def disable(klass)
        storage.delete(klass)
      end
    end
  end

  # Aggregates all callbacks on the selected key to call them.
  class Selected
    def initialize(callbacks = [])
      @callbacks = callbacks
    end

    def expose(*args)
      @callbacks.each { |c| c.call(*args) }
    end
  end

  # Selects the callback hashes in current thread.
  def self.in(key)
    Selected.new(Store.in(key))
  end

  attr_reader :callbacks

  # Manages callbacks in instances so we can manage sets of callbacks.
  def initialize
    @callbacks = {}
    enable
  end

  # @param key [String] the unique self explanatory name of the hook.
  def for(key)
    callbacks[key] ||= []
  end

  def enable
    Store.enable(self)
  end

  def disable
    Store.disable(self)
  end
end
