{ lib, nixpkgs, python3 }:

let
  # Get the python package set
  python = python3.python310;
  pkgs = python.pkgs;
  
  # List of packages we need
  targetPackages = [
    "fastmcp"
    "typer"
    "typing-extensions"
  ];
  
  # Check which packages exist
  checkPackage = name: 
    if pkgs ? ${name} then
      { name = name; available = true; }
    else
      { name = name; available = false; };
      
  results = map checkPackage targetPackages;
  
in
  lib.forEach results (result: 
    if result.available then
      "✅ ${result.name} - available in nixpkgs"
    else  
      "❌ ${result.name} - not available in nixpkgs"
  )
