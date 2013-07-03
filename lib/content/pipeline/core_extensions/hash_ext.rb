module CoreExtensions

  # --------------------------------------------------------------------------
  # Hash Extensions.
  # --------------------------------------------------------------------------

  module HashExt

    # ------------------------------------------------------------------------
    # Merge a hash, merging hashes in hashes with hashes in hashes if hashes.
    # ------------------------------------------------------------------------

    def deep_merge(new_hash)
      merge(new_hash) do |k, o, n|
        Hash === o && Hash === n ? o.deep_merge(n) : n
      end
    end
  end
end

Hash.send(:include, CoreExtensions::HashExt)
