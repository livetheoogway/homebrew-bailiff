class Bailiff < Formula
  desc "On-demand CLI tool manager with Zinit-like syntax for ZSH"
  homepage "https://github.com/livetheoogway/bailiff"
  url "https://github.com/livetheoogway/bailiff/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "6e827783fc65ec3bb109c008d2783de980b0677681abce27504502758065cf5b"
  license "MIT"

  depends_on "zsh" => :recommended

  def install
    # Install the script to share directory instead of bin
    # This makes it clear it's meant to be sourced, not executed directly
    (share/"bailiff").install "bailiff.sh"

    # Create a small wrapper script in bin that sources the main script
    # This allows users to run 'bailiff' command directly
    (bin/"bailiff").write <<~EOS
      #!/bin/sh
      if [ "$1" = "--source-script" ]; then
        # Return the path to the script for sourcing
        echo "#{share}/bailiff/bailiff.sh"
      else
        # Execute the script with the provided arguments
        exec zsh "#{share}/bailiff/bailiff.sh" "$@"
      fi
    EOS
    chmod 0755, bin/"bailiff"

    # Install documentation
    prefix.install "LICENSE", "README.md"

    # Install completions
    zsh_completion.install "completions/_bailiff" if File.exist?("completions/_bailiff")
  end

  def caveats
    <<~EOS
      To enable Bailiff with command-not-found handler support, add this to your ~/.zshrc:
      
        source "$(/opt/homebrew/bin/bailiff --source-script)"
        
      Then restart your shell or run: source ~/.zshrc
      
      Completions have been installed to:
        #{zsh_completion}
    EOS
  end

  test do
    assert_match "bailiff v1.0.5", shell_output("#{bin}/bailiff --version")
    # Test that the source script exists
    assert_predicate share/"bailiff/bailiff.sh", :exist?
  end
end
