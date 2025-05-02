class Bailiff < Formula
    desc "On-demand CLI tool manager with Zinit-like syntax for ZSH"
    homepage "https://github.com/livetheoogway/bailiff"
    url "https://github.com/livetheoogway/bailiff/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "0ab0aaac8537e328e8358480e1fc8f1a0813a837e0b0aab24a3d7a7e39b6c67f"
    license "MIT"
    
    def install
      bin.install "bailiff.sh" => "bailiff"
      prefix.install "LICENSE", "README.md"
      
      # Ensure the completions directory exists in your repository
      if File.exist?("completions")
        zsh_completion.install "completions/_bailiff" if File.exist?("completions/_bailiff")
      else
        # Create completions directory structure if it doesn't exist in repo
        (buildpath/"completions").mkpath
        (buildpath/"completions/_bailiff").write(zsh_completion_script)
        zsh_completion.install "completions/_bailiff"
      end
    end
    
    # Define the completion script directly in the formula
    def zsh_completion_script
      <<~EOS
      #compdef bailiff
      
      _bailiff() {
        local -a commands
        
        commands=(
          'brew:Specify Homebrew as package manager'
          'apt:Specify apt as package manager'
          'pacman:Specify pacman as package manager'
          '--force:Force check/install regardless of cache'
          '--list:List all summoned tools'
          '--clear-cache:Clear the cache'
          '--version:Show version'
          '--help:Show help'
          '-x:Verbose mode'
        )
        
        _describe -t commands 'bailiff commands' commands
      }
      
      _bailiff "$@"
      EOS
    end
    
    def caveats
      <<~EOS
        Add this to your .zshrc to enable Bailiff:
          source "$(brew --prefix)/bin/bailiff"
          
        Completions have been installed to:
          #{zsh_completion}
      EOS
    end
    
    test do
      assert_match "bailiff v1.0.0", shell_output("#{bin}/bailiff --version")
    end
  end