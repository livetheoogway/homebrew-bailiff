# In homebrew-bailiff/Formula/bailiff.rb
class Bailiff < Formula
    desc "On-demand CLI tool manager with Zinit-like syntax for ZSH"
    homepage "https://github.com/livetheoogway/bailiff"
    url "https://github.com/livetheoogway/bailiff/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "0ab0aaac8537e328e8358480e1fc8f1a0813a837e0b0aab24a3d7a7e39b6c67f"  # Replace with actual hash
    license "MIT"
    
    def install
      bin.install "bailiff.sh" => "bailiff"
      prefix.install "LICENSE", "README.md"
      zsh_completion.install "completions/_bailiff" if File.exist?("completions/_bailiff")
    end
    
    def caveats
      <<~EOS
        Add this to your .zshrc to enable Bailiff:
          source "$(brew --prefix)/bin/bailiff"
      EOS
    end
    
    test do
      assert_match "bailiff v1.0.0", shell_output("#{bin}/bailiff --version")
    end
  end