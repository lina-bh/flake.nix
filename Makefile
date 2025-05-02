.POSIX:

build:
	nixos-rebuild $(REBUILDFLAGS) --flake . build

update:
	nix flake update --flake .

boot:
	nixos-rebuild --use-remote-sudo --flake . boot

switch:
	nixos-rebuild --use-remote-sudo --flake . switch

.PHONY: update boot switch build
