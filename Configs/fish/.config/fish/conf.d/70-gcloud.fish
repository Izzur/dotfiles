# Google Cloud SDK. Ships its own PATH snippet; source it after 00-dotenv.fish
# so the wholesale PATH replacement there cannot erase it.
if test -f "$HOME/.config/google-cloud-sdk/path.fish.inc"
    source "$HOME/.config/google-cloud-sdk/path.fish.inc"
end
