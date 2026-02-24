# This module provides the assertion and warning system infrastructure similar to NixOS.
# It allows defining validation checks across the configuration to ensure that
# certain conditions are met before the configuration is considered valid.
#
# The implementation is based on NixOS's assertions module:
# https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/misc/assertions.nix
#
# Currently, this only defines the options schema, but doesn't implement the actual
# assertion checking functionality. This is needed as a placeholder to support
# mkRemovedOptionModule and other validation functions that depend on these options.
#
# TODO: Implement the full assertion checking logic similar to NixOS's activation system.
# Reference: <nixpkgs/nixos/modules/system/activation/top-level.nix>

{ lib, ... }:
{
  options = {
    assertions = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      internal = true;
      default = [ ];
      example = [
        {
          assertion = false;
          message = "you can't enable this for that reason";
        }
      ];
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

    warnings = lib.mkOption {
      internal = true;
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };
  };
}
