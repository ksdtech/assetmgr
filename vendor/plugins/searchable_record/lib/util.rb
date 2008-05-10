module SearchableRecord
  module Util   #:nodoc:
    def self.pruned_dup(hash, preserved_keys)
      hash = hash.to_hash
      
      dup_hash = { }

      preserved_keys.to_a.each do |key|
        if !hash[key.to_s].blank?         # find first with 'key'
          dup_hash[key] = hash[key.to_s]
        elsif !hash[key].blank?           # then with :key
          dup_hash[key] = hash[key]
        end
      end

      return dup_hash
    end

    def self.find_and_prune_dup(hash, preserved_keys)
    end

    def self.parse_positive_int(str)
      integer = str.to_i
      if integer > 0    # nil.to_i == 0
        return integer
      else
        return nil
      end
    end
  end
end
