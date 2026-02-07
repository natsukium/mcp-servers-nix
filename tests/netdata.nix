{ pkgs }:
let
  nd-mcp-pkg = pkgs.callPackage ../pkgs/official/netdata { };
in
{
  # Test that the package builds and binary exists
  test-netdata-build = pkgs.runCommand "test-netdata-build" { } ''
    touch $out
    # Verify binary exists and is executable
    test -x ${nd-mcp-pkg}/bin/nd-mcp
  '';

  # Test module integration
  test-netdata-module =
    let
      mcp-servers = import ../. { inherit pkgs; };
      evaluated-module = mcp-servers.lib.evalModule pkgs {
        programs.netdata = {
          enable = true;
          args = [ "ws://localhost:19999/mcp" ];
        };
      };
    in
    pkgs.runCommand "test-netdata-module" { nativeBuildInputs = with pkgs; [ gnugrep ]; } ''
      touch $out

      # Verify config file is generated
      test -f ${evaluated-module.config.configFile}

      # Verify nd-mcp is in the config
      grep -q "nd-mcp" ${evaluated-module.config.configFile}

      # Verify WebSocket URL is passed
      grep -q "ws://localhost:19999/mcp" ${evaluated-module.config.configFile}
    '';
}
