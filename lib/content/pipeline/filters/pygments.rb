require 'pygments'

# ----------------------------------------------------------------------------
# A filter that discovers pre tags and then syntax highlights them, also
# allowing for fallback to just wrapping them so they stay consistent.
# ----------------------------------------------------------------------------

class Content::Pipeline::Filters::Pygments < Content::Pipeline::Filter
  add_filter :pygments

  Matcher = /<pre>(.+)<\/pre>/m
  Templates = {
    :numb => %Q{<span class="line-number">%s</span>\n},
    :line => '<span class="line">%s</span>',
    :wrap => <<-HTML
      <figure class="code">
        <div class="highlight">
          <table>
            <tbody>
              <tr>
                <td class="gutter">
                  <pre>%s</pre>
                </td>
                <td class="code">
                  <pre><code class="%s">%s</code></pre>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </figure>
    HTML
  }

  # --------------------------------------------------------------------------
  # Searches for elements we want to transform and transforms them.
  # --------------------------------------------------------------------------

  private
  def pygments
    @str = @str.to_nokogiri_fragment
    @str.search('pre').each do |node|
      node.replace Templates[:wrap] %
        wrap(highlight(node.inner_text, node[:lang]), node[:lang] || 'text')
    end
  end

  # --------------------------------------------------------------------------
  # Goes through each line and wraps it as well as creates line numbers.
  # --------------------------------------------------------------------------

  private
  def wrap(str, lang)
    lines, numbs = '', ''; str.each_line.with_index(1) do |line, numb|
      lines+= Templates[:line] % line
      numbs+= Templates[:numb] % numb
    end

    [numbs, lang, lines]
  end

  # --------------------------------------------------------------------------
  # Wraps around Pygments catching a timeout error so that it can cont.
  # --------------------------------------------------------------------------

  private
  def highlight(str, lang)
    return str unless Pygments::Lexer[lang]
    Pygments::Lexer[lang].highlight(str) =~ Matcher ? $1 : str
  end
end
