{ ... }:
{
  xdg.configFile."k9s/config.yaml".text = ''
    k9s:
      liveViewAutoRefresh: false
      refreshRate: 2
      maxConnRetry: 5
      readOnly: false
      ui:
        enableMouse: false
        headless: false
        logoless: false
        crumbsless: false
        noIcons: false
        reactive: false
        skin: transparent
  '';

  home.file.".local/share/nautilus/scripts/view_certificate.sh".text = ''
    #!/bin/bash

    for filename in "$@"; do
        VERIFY_OUTPUT=$(osslsigncode verify "$filename" 2>&1)
        
        if [[ "$VERIFY_OUTPUT" == *"Signature verification: ok"* ]]; then
            HEADER="✅ SIGNATURE IS VALID"
        else
            HEADER="❌ INVALID OR UNSIGNED"
        fi

        SIGFILE=$(mktemp)
        osslsigncode extract-signature -in "$filename" -out "$SIGFILE" &> /dev/null
        
        if [ -s "$SIGFILE" ]; then
            CERT_DETAILS=$(openssl pkcs7 -inform der -in "$SIGFILE" -print_certs -text 2>&1)
        else
            CERT_DETAILS="No certificate found to inspect."
        fi

        rm "$SIGFILE"

        (
            echo "=================================================="
            echo "$HEADER"
            echo "File: $filename"
            echo "=================================================="
            echo ""
            echo "--- VERIFICATION OUTPUT ---"
            echo "$VERIFY_OUTPUT"
            echo ""
            echo "=================================================="
            echo "         CERTIFICATE DETAILS (INSPECTION)         "
            echo "=================================================="
            echo "$CERT_DETAILS"
        ) | zenity --text-info \
          --title="Signature Inspector - $filename" \
          --width=800 --height=600 \
          --font="Monospace 10"
    done
  '';
}
