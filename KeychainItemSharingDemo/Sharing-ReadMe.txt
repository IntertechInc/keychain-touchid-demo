The sharing demo requires a few steps that couldn't be
included in these files...

1) You need to create two "explicit id" provisioning profiles
   (one for each target).  The App ID for both profiles must use the
   SAME AppID-prefix, though the bundle IDs will be unique, by matching
   the bundle id specified in each target.
   For example if X123X is the AppID-Prefix...
                App Id #1: X123X.com.intertech.KeychainTouchIdDemo
                App Id #2: X123X.com.intertech.KeychainItemSharingDemo

2) Make sure each target is set to use the appropriate Provisioning Profile

3) Turn on the Keychain Sharing entitlement in each app
(Target -> Capabilities), specifying the same group in each.

4) Add the following item to the attribute dictionary in
KeychainPasswordViewController (both the save and load methods):
kSecAttrAccessGroup : "<APPID-PREFIX>.<SHARING-GROUP>"
For example:
kSecAttrAccessGroup : "X123X.com.intertech.keysharing"