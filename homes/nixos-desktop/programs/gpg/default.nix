{ pkgs, ... }:

let
  KEYID = "0xD4B98575F4F55465";
in
{
  home.sessionVariables = { inherit KEYID; };

  programs.gpg = {
    enable = true;

    mutableKeys = true;
    mutableTrust = true;

    publicKeys = [
      { source = ./pubkey.asc; trust = "ultimate"; }
    ];

    settings = {
      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = "AES256 AES192 AES";
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      # Default preferences for new keys
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # Show Unix timestamps
      fixed-list-mode = true;
      # No comments in signature
      no-comments = true;
      # No version in output
      no-emit-version = true;
      # Disable banner
      no-greeting = true;
      # Long hexidecimal key format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = true;
      # Display key origins and updates
      #with-key-origin
      # Cross-certify subkeys are present and valid
      require-cross-certification = true;
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;
      # Enable smartcard
      use-agent = true;
      # Disable recipient key ID in messages
      throw-keyids = true;
      # Default/trusted key ID to use (helpful with throw-keyids)
      default-key = KEYID;
      trusted-key = KEYID;
      # Group recipient keys (preferred ID last)
      # group = "keygroup = 0xFF00000000000001 0xFF00000000000002 0xFF3E7D88647EBCDB";
      # Keyserver URL
      # keyserver = "hkps://keys.openpgp.org";
      # keyserver = "hkps://keyserver.ubuntu.com:443";
      # keyserver = "hkps://hkps.pool.sks-keyservers.net";
      # keyserver = "hkps://pgp.ocf.berkeley.edu";
      # Proxy to use for keyservers
      # keyserver-options = "http-proxy=http://127.0.0.1:8118";
      # keyserver-options = "http-proxy=socks5-hostname://127.0.0.1:9050";
      # Verbose output
      # verbose = true;
      # Show expired subkeys
      # list-options = "show-unusable-subkeys";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    pinentryFlavor = "curses";
    extraConfig = ''
      pinentry-program "${pkgs.pinentry-curses}/bin/pinentry-curses"
    '';
  };
}
