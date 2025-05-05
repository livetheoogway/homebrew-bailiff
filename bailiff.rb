class Bailiff < Formula
  desc "On-demand CLI tool manager with support for ZSH, Bash, Fish, and KSH"
  homepage "https://github.com/livetheoogway/bailiff"
  url "https://github.com/livetheoogway/bailiff/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "bcbc581324c2d2d1e053dc50fcd17a48efd4162324f22b5bbd063db53c31bf0e"
  license "MIT"

  # No specific shell dependency, works with multiple shells

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
        # Detect shell and use appropriate one
        if [ -n "$ZSH_VERSION" ]; then
          exec zsh "#{share}/bailiff/bailiff.sh" "$@"
        elif [ -n "$BASH_VERSION" ]; then
          exec bash "#{share}/bailiff/bailiff.sh" "$@"
        elif command -v fish >/dev/null 2>&1; then
          exec fish "#{share}/bailiff/bailiff.sh" "$@"
        else
          # Default to bash if we can't detect
          exec bash "#{share}/bailiff/bailiff.sh" "$@"
        fi
      fi
    EOS
    chmod 0755, bin/"bailiff"

    # Install documentation
    prefix.install "LICENSE", "README.md"

    # Install completions
    zsh_completion.install "completions/_bailiff" if File.exist?("completions/_bailiff")
    bash_completion.install "completions/bailiff.bash" => "bailiff" if File.exist?("completions/bailiff.bash")
    fish_completion.install "completions/bailiff.fish" if File.exist?("completions/bailiff.fish")

    # Install fish command-not-found handler
    (share/"fish/functions").install "completions/fish_command_not_found.fish" if File.exist?("completions/fish_command_not_found.fish")
  end

  def caveats
    <<~EOS
      To enable Bailiff with command-not-found handler support, add this to your shell configuration file:
      
      For ZSH (in ~/.zshrc):
        source "$(/opt/homebrew/bin/bailiff --source-script)"
      
      For Bash (in ~/.bashrc or ~/.bash_profile):
        source "$(/opt/homebrew/bin/bailiff --source-script)"
      
      For Fish (in ~/.config/fish/config.fish):
        source (/opt/homebrew/bin/bailiff --source-script)
      
      Then restart your shell or source your configuration file.
      
      Completions have been installed to:
        ZSH:  #{zsh_completion}
        Bash: #{bash_completion}
        Fish: #{fish_completion}
      
      For Fish shell, a command-not-found handler has been installed to:
        #{share}/fish/functions/fish_command_not_found.fish
      
      You may need to manually copy this file to ~/.config/fish/functions/ for it to work.
    EOS
  end

  test do
    assert_match "bailiff v1.0.6", shell_output("#{bin}/bailiff --version")
    # Test that the source script exists
    assert_predicate share/"bailiff/bailiff.sh", :exist?
  end
end
