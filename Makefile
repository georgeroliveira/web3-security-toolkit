.PHONY: recon
recon:
	@echo "[*] Refreshing TVL..."
	PYTHONPATH=bounty-pocs/recon/scripts bash bounty-pocs/recon/scripts/refresh-tvl.sh
	@echo "[*] Fetching programs..."
	PYTHONPATH=bounty-pocs/recon/scripts bash bounty-pocs/recon/scripts/fetch-programs.sh
	@echo "[✓] Recon pipeline complete"
