#!/usr/bin/env bash
# passive-recon.sh
# Small passive recon aggregator for labs / education (whois, nslookup, dig...).
# NON-INTRUSIVE: no port scans or active exploit attempts.
# Usage: ./passive-recon.sh <target> [output-dir]
set -euo pipefail

TARGET="${1:-}"
OUTDIR="${2:-./recon-output}"
TS=$(date -u +"%Y%m%dT%H%M%SZ")
[ -z "$TARGET" ] && echo "Usage: $0 <domain|hostname|ip> [output-dir]" && exit 2

mkdir -p "$OUTDIR"
OUTFILE="${OUTDIR}/${TARGET//\//_}_${TS}.txt"

# Helper: print a section header
hdr() { printf "\n===== %s =====\n\n" "$1"; }

# Check for required commands
REQUIRED="whois dig nslookup host curl"
for c in $REQUIRED; do
  if ! command -v "$c" >/dev/null 2>&1; then
    echo "Required command not found: $c. Install it (e.g. apt install dnsutils bind9-host whois curl)"; exit 3
  fi
done

{
echo "Passive Recon Report"
echo "Target: $TARGET"
echo "Generated: $(date -u +"%Y-%m-%d %H:%M:%SZ") (UTC)"
echo "Note: Passive/non-intrusive actions only (WHOIS, DNS queries, HTTP headers)."
hdr "WHOIS"
# whois can take a while on some objects
whois "$TARGET" 2>/dev/null || echo "whois: no data or failed."

hdr "DNS: Basic records (A, AAAA, NS, MX, TXT, SOA)"
echo "--- A records ---"
dig +noall +answer A "$TARGET" || echo "no A record."
echo
echo "--- AAAA records ---"
dig +noall +answer AAAA "$TARGET" || echo "no AAAA record."
echo
echo "--- NS records ---"
dig +noall +answer NS "$TARGET" || echo "no NS record."
echo
echo "--- MX records ---"
dig +noall +answer MX "$TARGET" || echo "no MX record."
echo
echo "--- TXT records ---"
dig +noall +answer TXT "$TARGET" || echo "no TXT record."
echo
echo "--- SOA ---"
dig +noall +answer SOA "$TARGET" || echo "no SOA record."

hdr "Reverse DNS if argument looks like an IP"
# simple IP check
if [[ "$TARGET" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  nslookup "$TARGET" | sed -n '1,120p'
  echo
  echo "--- PTR (via dig) ---"
  dig +noall +answer -x "$TARGET" || echo "no ptr"
else
  echo "Skipping reverse DNS (target does not look like IPv4)."
fi

hdr "Host and nslookup quick checks"
echo "host lookup:"
host "$TARGET" 2>/dev/null || true
echo
echo "nslookup (default):"
nslookup "$TARGET" 2>/dev/null || true

hdr "HTTP(S) headers and common endpoints (HEAD requests)"
# try http and https (timeout short)
curl -I --max-time 8 --location --silent "http://$TARGET" -D - || echo "http: no response or timed out"
echo
curl -I --max-time 8 --location --silent "https://$TARGET" -D - || echo "https: no response or timed out"

hdr "Robots.txt & security.txt (.well-known)"
echo "robots.txt (first 2000 bytes):"
curl --max-time 6 --silent --show-error "https://$TARGET/robots.txt" || echo "no robots.txt over https"
echo
echo "If https robots was missing, try http robots.txt:"
curl --max-time 6 --silent --show-error "http://$TARGET/robots.txt" || true
echo
echo ".well-known/security.txt (if present):"
curl --max-time 6 --silent --show-error "https://$TARGET/.well-known/security.txt" || echo "no security.txt"

hdr "Certificate Transparency / TLS (subject, issuer) -- simple check via openssl (if available)"
if command -v openssl >/dev/null 2>&1; then
  # only attempt if port 443 is reachable quickly
  timeout 6 bash -c "echo | openssl s_client -servername $TARGET -connect $TARGET:443 2>/dev/null | openssl x509 -noout -subject -issuer -dates" \
    || echo "openssl: TLS connection or certificate read failed/timeout"
else
  echo "openssl not installed; skipping TLS cert extraction."
fi

hdr "Basic CDN / Caching headers (from HTTPS response shown above)"
echo "Look at the 'Server' and caching headers in the HTTP responses above (Server, X-Cache, Via, CF-Cache-Status, etc.)."

hdr "Optional: Certificate Transparency (crt.sh) lookup (public web query)"
echo "You can run the following if you want cert transparency info (this queries crt.sh):"
echo "curl -s 'https://crt.sh/?q=%25.$TARGET&output=json' | sed -n '1,10p'  # limited preview"

hdr "Notes & next steps"
echo "- This script is intentionally limited to passive, non-scanning actions."
echo "- For passive subdomain enumeration you can add calls to tools like 'amass enum -passive' or query certificate logs (crt.sh) or securitytrails/virustotal APIs (requires keys)."
echo "- Save and review outputs in $OUTFILE for each target."

} | tee "$OUTFILE"

echo
echo "Report saved to: $OUTFILE"
