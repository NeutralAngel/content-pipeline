module CoreExtensions
  module KernExt
    private
    def require_or_fail(file, fail_message)
      require file
    rescue  LoadError
      raise LoadError, fail_message
    end
  end
end

# ----------------------------------------------------------------------------

Kernel.send(:include, CoreExtensions::KernExt)
