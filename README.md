# Agora Video Call With Universal Links

This repository is an example project showing how you can use universal links to launch a video call.

To run this repo, you will need to:

1. Get your DEVELOPMENT_TEAM and change the PRODUCT_BUNDLE_IDENTIFIER to a unique value
2. Change these values inside the file `apple-app-site-association`
3. Upload `apple-app-site-association` to your website under `.well-known/`
4. Update the applinks in "Associated Domains" in Xcode. These are located under the target's Capabilities.
5. Fill in the placeholders that Xcode will flag.

---

Check out [the full guide](Universal-Links-Guide.md) to see how universal links work.